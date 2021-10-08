# Info concerning the SPM multimodal dataset

Extracted from the SPM8 manual:

https://www.fil.ion.ucl.ac.uk/spm/doc/spm8_manual.pdf#Chap:data:multimodal

---

## dataset

Authors: Rik Henson

## task

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

```matlab
task_name = 'FaceSymmetry';
```

## anat

The T1-weighted structural MRI of a young male was acquired on a 1.5T Siemens
Sonata via an MDEFT sequence

```matlab
anat.manufacturer = 'Siemens';
anat.model = 'Sonata';
anat.field_strength = 1.5;
```

## func

The fMRI data were acquired using a gradient-echo EPI sequence on a 3T Siemens
TIM Trio, with 32, 3mm slices (skip 0.75mm)

```matlab
func.nb_slices = 32;
func.repetition_time = 2;
func.discarded_volumes = 5;
func.manufacturer = 'Siemens';
func.model = 'TIM Trio';
func.field_strength = 3;
```

## eeg

The EEG data were acquired on a 128-channel ActiveTwo system, sampled at 2048
Hz, plus electrodes on left earlobe, right earlobe, and two bipolar channels to
measure HEOG and VEOG. The 128 scalp channels are named: 32 A (Back), 32 B
(Right), 32 C (Front) and 32 D (Left).

## meg

The MEG data were acquired on a 275 channel CTF/VSM system, using second-order
axial gradiometers and synthetic third gradient for denoising and sampled at 480
Hz. There are actually 274 MEG channels in this dataset since the system it was
recorded on had one faulty sensor. Two runs (sessions) of the protocol have been
saved in two CTF datasets (each one is a directory with multiple files)

```json
"Manufacturer": "CTF",
"MEGChannelCount": 274,
"SamplingFrequency": 480,
"SoftwareFilters": {
    "SpatialCompensation": {
        "GradientOrder": 3
    }
```
