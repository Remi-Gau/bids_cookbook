<!-- TODO
- conversion script for MEG events
- link to BEPs have a look and contribute
- use BEPs to organize yet unsupported data -->

<!-- # Converting the SPM multimodal tutorial dataset

Converts the multimodal dataset from SPM and to BIDS

Source: https://www.fil.ion.ucl.ac.uk/spm/data/mmfaces/

Requires SPM12 and
[BIDS-matlab](https://github.com/bids-standard/bids-matlab/tree/dev).

Place and unzip the zip files in `source` folder and run
`code/code/convert_spm_multimodal_ds.m` -->

# A BIDS cookbook

How to cook a BIDS cookbook dataset by hand and from scratch

<h3>
    This a simple recipe to convert your neuroimaging data into a valid BIDS dataset.
</h3>

**table of content**

- [Ingredients](#Ingredients)
- Recipe
- Useful links

---

<details><summary> <b>Click me...</b> </summary><br>

... to see what I hide !!!

<center>
<a href="https://twitter.com/RemiGau/status/1115513296134778880" target="_blank">
    <img src="https://pbs.twimg.com/media/D3sYRfhWkAAlevT?format=jpg&name=small" width="500" />
</a>
</center>

</details>

---

## Ingredients & tools

Get them fresh from your local ~~market~~:

- MRI scanner 🧲
- EEG amp 🌩
- MEG [:octopus:](https://theupturnedmicroscope.com/comic/squid/)
- ...

<details><summary> <b> 🧠 some <code>source</code> data to be converted into BIDS </b> </summary><br>
    <p>
        We will work with the <a href="https://www.fil.ion.ucl.ac.uk/spm/data/mmfaces/" target="_blank">multi-modal face dataset from SPM</a>.
    </p>
    <p>
        This dataset contains EEG, MEG and fMRI data on the same subject within the same paradigm.
    </p>
    <p>
        Very often MRI source ata will be in a DICOM format and will required to be converted.
        Here the MRI data is in 3D Nifti Nifti  format <code>.hdr/.img</code> and
        we will need to change that to a 4D Nifti <code>.nii</code> format.
    </p>
</details>

<details><summary> <b> 🖋 a text editor </b> </summary><br>
    Several common options top choose from:
    <ul>
        <li><a href="https://code.visualstudio.com" target="_blank">Visual Studio code</a></li>
        <li><a href="https://www.sublimetext.com/" target="_blank">Sublime</a></li>
        <li><a href="https://atom.io/" target="_blank">Atom</a></li>
        <li>Notepad does not count.</li>
    </ul>
</details>

<details><summary> <b> ♻ some format conversion tools </b> </summary><br>
    For the MRI data we will be using some of the SPM built in functions.
</details>

---

## Recipe

### 1. Preheat the oven: creating folders

Create a `raw` folder to host your BIDS data and inside it create:

- a `sourcedata` folder and put your `source` data in it
- a `code/conversion` folder and put this `cookbook.md` in it
- a subject folder: `sub-01`
  - with session folder: `ses-mri`
    - with an `anat` folder for the structural MRI data
    - with an `func` folder for the functional MRI data

By now you should have this.

```
└── raw
    ├── code
    │   └── conversion
    ├── sourcedata
    └── sub-001
        └── ses-mri
            ├── anat
            └── func
```

### 2. Starters: converting the MRI anatomical file

- In Matlab launch SPM

```matlab
SPM fmri
```

- In SPM
  - `Batch --> SPM --> Utils --> 3D to 4D File conversion`
  - select the `*.img` file to convert
  - keep track of what you did by saving the batch in `code/conversion`
  - run the batch

#### 2.a Cooking is not just about the taste, it is also about how things look: naming files

- extension
- suffix
- entity-label pairs

- filename template

- entity table

#### 2.b Taste your dish while you prepare it: using the BIDS validator

https://bids-standard.github.io/bids-validator/

#### 2.c Season to taste: adding missing files

- `dataset_description.json`
    - from the specification
- `README`
    - template

#### 2.d Icing on the cake: adding extra information

- `partipants.tsv` -->
- can use excel to create

#### 2.e BIDS is data jam: let's preserve some

```bash
datalad create --force -c text2git .
datalad save -m 'initial commit'
```

### 3 functional

2 runs

convert img --> nii

use validator & add missing file

.json --> taskname

events.tsv --> script

inheritance principle --> single json

<!--
- Defacing
- MRIQC
- Things to improve
-->

---

## Useful links

- [BIDS specification](https://bids-specification.readthedocs.io)
- [BIDS starter kit](https://github.com/bids-standard/bids-starter-kit)
  - [templates](https://github.com/bids-standard/bids-starter-kit/tree/main/templates)
  - [wiki](https://github.com/bids-standard/bids-starter-kit/wiki)
    - [validator](https://github.com/bids-standard/bids-starter-kit/wiki/bids-validator-info)
- [BIDS validator](https://github.com/bids-standard/bids-validator)
- [BIDS examples](https://github.com/bids-standard/bids-examples)
- [Neurostars forum](https://neurostars.org/tag/bids)
- Other conversion tutorial
  - https://reproducibility.stanford.edu/bids-tutorial-series-part-1a/
  - https://www.fieldtriptoolbox.org/example/bids_mous/
- [Conversion tools](https://bids.neuroimaging.io/benefits.html#converters)
- [Datalad handbook](http://handbook.datalad.org/en/latest/index.html)
- [GIN](https://gin.g-node.org/)

---
