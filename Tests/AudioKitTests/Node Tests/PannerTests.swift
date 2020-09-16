// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AudioKit
import XCTest

class AKPannerTests: XCTestCase {

    func testDefault() {
        let engine = AudioEngine()
        let input = Oscillator()
        engine.output = AKPanner(input)
        input.start()
        let audio = engine.startTest(totalDuration: 1.0)
        audio.append(engine.render(duration: 1.0))
        testMD5(audio)
    }

    func testBypass() {
        let engine = AudioEngine()
        let input = Oscillator()
        let pan = AKPanner(input, pan: -1)
        pan.bypass()
        engine.output = pan
        input.start()
        let audio = engine.startTest(totalDuration: 1.0)
        audio.append(engine.render(duration: 1.0))
        testMD5(audio)
    }

    func testPanLeft() {
        let engine = AudioEngine()
        let input = Oscillator()
        engine.output = AKPanner(input, pan: -1)
        input.start()
        let audio = engine.startTest(totalDuration: 1.0)
        audio.append(engine.render(duration: 1.0))
        testMD5(audio)
    }

    func testPanRight() {
        let engine = AudioEngine()
        let input = Oscillator()
        engine.output = AKPanner(input, pan: 1)
        input.start()
        let audio = engine.startTest(totalDuration: 1.0)
        audio.append(engine.render(duration: 1.0))
        testMD5(audio)
    }
}
