// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// Based on the Pink Trombone algorithm by Neil Thapen, this implements a physical
/// model of the vocal tract glottal pulse wave. The tract model is based on the
/// classic Kelly-Lochbaum
/// segmented cylindrical 1d waveguide model, and the glottal pulse wave is a
/// LF glottal pulse model.
/// 
public class VocalTract: AKNode, AKComponent, AKToggleable {

    public static let ComponentDescription = AudioComponentDescription(generator: "vocw")

    public typealias AKAudioUnitType = InternalAU

    public private(set) var internalAU: AKAudioUnitType?

    // MARK: - Parameters

    public static let frequencyDef = AKNodeParameterDef(
        identifier: "frequency",
        name: "Glottal frequency.",
        address: akGetParameterAddress("VocalTractParameterFrequency"),
        range: 0.0 ... 22_050.0,
        unit: .hertz,
        flags: .default)

    /// Glottal frequency.
    @Parameter public var frequency: AUValue

    public static let tonguePositionDef = AKNodeParameterDef(
        identifier: "tonguePosition",
        name: "Tongue position (0-1)",
        address: akGetParameterAddress("VocalTractParameterTonguePosition"),
        range: 0.0 ... 1.0,
        unit: .generic,
        flags: .default)

    /// Tongue position (0-1)
    @Parameter public var tonguePosition: AUValue

    public static let tongueDiameterDef = AKNodeParameterDef(
        identifier: "tongueDiameter",
        name: "Tongue diameter (0-1)",
        address: akGetParameterAddress("VocalTractParameterTongueDiameter"),
        range: 0.0 ... 1.0,
        unit: .generic,
        flags: .default)

    /// Tongue diameter (0-1)
    @Parameter public var tongueDiameter: AUValue

    public static let tensenessDef = AKNodeParameterDef(
        identifier: "tenseness",
        name: "Vocal tenseness. 0 = all breath. 1=fully saturated.",
        address: akGetParameterAddress("VocalTractParameterTenseness"),
        range: 0.0 ... 1.0,
        unit: .generic,
        flags: .default)

    /// Vocal tenseness. 0 = all breath. 1=fully saturated.
    @Parameter public var tenseness: AUValue

    public static let nasalityDef = AKNodeParameterDef(
        identifier: "nasality",
        name: "Sets the velum size. Larger values of this creates more nasally sounds.",
        address: akGetParameterAddress("VocalTractParameterNasality"),
        range: 0.0 ... 1.0,
        unit: .generic,
        flags: .default)

    /// Sets the velum size. Larger values of this creates more nasally sounds.
    @Parameter public var nasality: AUValue

    // MARK: - Audio Unit

    public class InternalAU: AudioUnitBase {

        public override func getParameterDefs() -> [AKNodeParameterDef] {
            [VocalTract.frequencyDef,
             VocalTract.tonguePositionDef,
             VocalTract.tongueDiameterDef,
             VocalTract.tensenessDef,
             VocalTract.nasalityDef]
        }

        public override func createDSP() -> AKDSPRef {
            akCreateDSP("VocalTractDSP")
        }
    }

    // MARK: - Initialization

    /// Initialize this vocal tract node
    ///
    /// - Parameters:
    ///   - frequency: Glottal frequency.
    ///   - tonguePosition: Tongue position (0-1)
    ///   - tongueDiameter: Tongue diameter (0-1)
    ///   - tenseness: Vocal tenseness. 0 = all breath. 1=fully saturated.
    ///   - nasality: Sets the velum size. Larger values of this creates more nasally sounds.
    ///
    public init(
        frequency: AUValue = 160.0,
        tonguePosition: AUValue = 0.5,
        tongueDiameter: AUValue = 1.0,
        tenseness: AUValue = 0.6,
        nasality: AUValue = 0.0
    ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AKAudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            self.frequency = frequency
            self.tonguePosition = tonguePosition
            self.tongueDiameter = tongueDiameter
            self.tenseness = tenseness
            self.nasality = nasality
        }

    }
}
