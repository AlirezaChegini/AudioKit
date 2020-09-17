// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

#import "STKInstrumentDSP.hpp"

#include "Flute.h"

class FluteDSP : public AKSTKInstrumentDSP {
private:
    stk::Flute *flute = nullptr;

public:
    FluteDSP() {}
    ~FluteDSP() = default;

    void init(int channelCount, double sampleRate) override {
        AKDSPBase::init(channelCount, sampleRate);

        stk::Stk::setSampleRate(sampleRate);
        flute = new stk::Flute(/*lowestFrequency*/100);
    }

    stk::Instrmnt* getInstrument() override {
        return flute;
    }

    void deinit() override {
        AKDSPBase::deinit();
        delete flute;
        flute = nullptr;
    }

};

AK_REGISTER_DSP(FluteDSP);
