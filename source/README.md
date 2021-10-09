# Info concerning the SPM multimodal dataset

Data source: https://www.fil.ion.ucl.ac.uk/spm/data/mmfaces/

The following information was extracted from the SPM8 manual:
https://www.fil.ion.ucl.ac.uk/spm/doc/spm8_manual.pdf#Chap:data:multimodal

To convert the data, place and unzip the zip files in this `source` folder and
run `../code/convert_spm_multimodal_ds.m` with Matlab or Octave. This requires
SPM12 and [BIDS-matlab](https://github.com/bids-standard/bids-matlab/tree/dev).

## Dataset

Authors:

- Rik Henson

Publication:

- Henson et al 2003 (???)

## Task

The basic paradigm involves randomised presentation of at least 86 faces and 86
scrambled faces (Figure 37.1), based on Phase 1 of a previous study by Henson et
al (2003). The scrambled faces were created by 2D Fourier transformation, random
phase permutation, inverse transformation and outline-masking of each face. Thus
faces and scrambled faces are closely matched for low-level visual properties
such as spatial frequency content.

Half the faces were famous, but this factor is collapsed in the current
analyses. Each face required a four-way, left-right symmetry judgment (mean RTs
over a second; judgments roughly orthogonal to conditions; reasons for this task
are explained in Henson et al, 2003). The subject was instructed not to blink
while the fixation cross was present on the screen.

```
task = face symmetry
```

## Anat

The T1-weighted structural MRI of a young male was acquired on a 1.5T Siemens
Sonata via an MDEFT sequenc.

```
manufacturer = Siemens
model = Sonata
field_strength = 1.5
```

## Func

The fMRI data were acquired using a gradient-echo EPI sequence on a 3T Siemens
TIM Trio, with 32, 3mm slices (skip 0.75mm).

```
number of slices = 32;
number of discarded volumes = 5;
field strength = 3
manufacturer = Siemens
repetition time = 2
model = TIM Trio
field strength = 3
```

## EEG

The EEG data were acquired on a 128-channel ActiveTwo system, sampled at 2048
Hz, plus electrodes on left earlobe, right earlobe, and two bipolar channels to
measure HEOG and VEOG. The 128 scalp channels are named: 32 A (Back), 32 B
(Right), 32 C (Front) and 32 D (Left).

## MEG

The MEG data were acquired on a 275 channel CTF/VSM system, using second-order
axial gradiometers and synthetic third gradient for denoising and sampled at 480
Hz. There are actually 274 MEG channels in this dataset since the system it was
recorded on had one faulty sensor. Two runs (sessions) of the protocol have been
saved in two CTF datasets (each one is a directory with multiple files)

```json
{
    "Manufacturer": "CTF",
    "MEGChannelCount": 274,
    "SamplingFrequency": 480,
    "SoftwareFilters": {
        "SpatialCompensation": {
            "GradientOrder": 3
        }
}
```
