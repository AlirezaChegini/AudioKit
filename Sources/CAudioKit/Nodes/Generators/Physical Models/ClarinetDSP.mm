// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

#import "STKInstrumentDSP.hpp"

#include "Clarinet.h"

class ClarinetDSP : public AKSTKInstrumentDSP {
private:
    stk::Clarinet *clarinet = nullptr;

public:
    ClarinetDSP() {}
    ~ClarinetDSP() = default;

    void init(int channelCount, double sampleRate) override {
        AKDSPBase::init(channelCount, sampleRate);

        stk::Stk::setSampleRate(sampleRate);
        clarinet = new stk::Clarinet(/*lowestFrequency*/100);
    }

    stk::Instrmnt* getInstrument() override {
        return clarinet;
    }

    void deinit() override {
        AKDSPBase::deinit();
        delete clarinet;
        clarinet = nullptr;
    }

};

AK_REGISTER_DSP(ClarinetDSP);
