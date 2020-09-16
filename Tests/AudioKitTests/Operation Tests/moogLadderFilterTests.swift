// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AudioKit
import XCTest

class MoogLadderFilterTests: XCTestCase {

    func testDefault() {
        let engine = AudioEngine()
        let input = Oscillator()
        engine.output = AKOperationEffect(input) { $0.moogLadderFilter() }
        input.start()
        let audio = engine.startTest(totalDuration: 1.0)
        audio.append(engine.render(duration: 1.0))
        testMD5(audio)
    }

}
