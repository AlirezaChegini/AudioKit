//
//  AKFMOscillatorDSPKernel.hpp
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2016 Aurelius Prochazka. All rights reserved.
//

#ifndef AKFMOscillatorDSPKernel_hpp
#define AKFMOscillatorDSPKernel_hpp

#import "AKDSPKernel.hpp"
#import "AKParameterRamper.hpp"

extern "C" {
#include "soundpipe.h"
}

enum {
    baseFrequencyAddress = 0,
    carrierMultiplierAddress = 1,
    modulatingMultiplierAddress = 2,
    modulationIndexAddress = 3,
    amplitudeAddress = 4
};

class AKFMOscillatorDSPKernel : public AKDSPKernel {
public:
    // MARK: Member Functions

    AKFMOscillatorDSPKernel() {}

    void init(int channelCount, double inSampleRate) {
        channels = channelCount;

        sampleRate = float(inSampleRate);

        sp_create(&sp);
        sp_fosc_create(&fosc);
        sp_fosc_init(sp, fosc, ftbl);
        
        fosc->freq = 440;
        fosc->car = 1.0;
        fosc->mod = 1;
        fosc->indx = 1;
        fosc->amp = 1;
    }

    void setupTable(uint32_t size) {
        ftbl_size = size;
        sp_ftbl_create(sp, &ftbl, ftbl_size);
    }
    
    void setTableValue(uint32_t index, float value) {
        ftbl->tbl[index] = value;
    }
    
    void start() {
        started = true;
    }

    void stop() {
        started = false;
    }

    void destroy() {
        sp_fosc_destroy(&fosc);
        sp_destroy(&sp);
    }

    void reset() {
    }

    void setParameter(AUParameterAddress address, AUValue value) {
        switch (address) {
            case baseFrequencyAddress:
                baseFrequencyRamper.set(clamp(value, (float)0.0, (float)20000.0));
                break;

            case carrierMultiplierAddress:
                carrierMultiplierRamper.set(clamp(value, (float)0.0, (float)1000.0));
                break;

            case modulatingMultiplierAddress:
                modulatingMultiplierRamper.set(clamp(value, (float)0, (float)1000));
                break;

            case modulationIndexAddress:
                modulationIndexRamper.set(clamp(value, (float)0, (float)1000));
                break;

            case amplitudeAddress:
                amplitudeRamper.set(clamp(value, (float)0, (float)10));
                break;

        }
    }

    AUValue getParameter(AUParameterAddress address) {
        switch (address) {
            case baseFrequencyAddress:
                return baseFrequencyRamper.goal();

            case carrierMultiplierAddress:
                return carrierMultiplierRamper.goal();

            case modulatingMultiplierAddress:
                return modulatingMultiplierRamper.goal();

            case modulationIndexAddress:
                return modulationIndexRamper.goal();

            case amplitudeAddress:
                return amplitudeRamper.goal();

            default: return 0.0f;
        }
    }

    void startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) override {
        switch (address) {
            case baseFrequencyAddress:
                baseFrequencyRamper.startRamp(clamp(value, (float)0.0, (float)20000.0), duration);
                break;

            case carrierMultiplierAddress:
                carrierMultiplierRamper.startRamp(clamp(value, (float)0.0, (float)1000.0), duration);
                break;

            case modulatingMultiplierAddress:
                modulatingMultiplierRamper.startRamp(clamp(value, (float)0, (float)1000), duration);
                break;

            case modulationIndexAddress:
                modulationIndexRamper.startRamp(clamp(value, (float)0, (float)1000), duration);
                break;

            case amplitudeAddress:
                amplitudeRamper.startRamp(clamp(value, (float)0, (float)10), duration);
                break;

        }
    }

    void setBuffer(AudioBufferList *outBufferList) {
        outBufferListPtr = outBufferList;
    }

    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override {
        // For each sample.
        for (int frameIndex = 0; frameIndex < frameCount; ++frameIndex) {
            double baseFrequency = double(baseFrequencyRamper.getStep());
            double carrierMultiplier = double(carrierMultiplierRamper.getStep());
            double modulatingMultiplier = double(modulatingMultiplierRamper.getStep());
            double modulationIndex = double(modulationIndexRamper.getStep());
            double amplitude = double(amplitudeRamper.getStep());

            int frameOffset = int(frameIndex + bufferOffset);

            fosc->freq = (float)baseFrequency;
            fosc->car = (float)carrierMultiplier;
            fosc->mod = (float)modulatingMultiplier;
            fosc->indx = (float)modulationIndex;
            fosc->amp = (float)amplitude;

            float temp = 0;
            for (int channel = 0; channel < channels; ++channel) {
                float *out = (float *)outBufferListPtr->mBuffers[channel].mData + frameOffset;
                if (started) {
                    if (channel == 0) {
                        sp_fosc_compute(sp, fosc, nil, &temp);
                    }
                    *out = temp;
                } else {
                    *out = 0.0;
                }
            }
        }
    }

    // MARK: Member Variables

private:

    int channels = 2;
    float sampleRate = 44100.0;

    AudioBufferList *outBufferListPtr = nullptr;

    sp_data *sp;
    sp_fosc *fosc;
    sp_ftbl *ftbl;
    UInt32 ftbl_size = 4096;
    
public:
    bool started = false;
    AKParameterRamper baseFrequencyRamper = 440;
    AKParameterRamper carrierMultiplierRamper = 1.0;
    AKParameterRamper modulatingMultiplierRamper = 1;
    AKParameterRamper modulationIndexRamper = 1;
    AKParameterRamper amplitudeRamper = 1;
};

#endif /* AKFMOscillatorDSPKernel_hpp */
