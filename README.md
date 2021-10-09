<!-- TODO
- conversion script for MEG events
- link to BEPs have a look and contribute
- use BEPs to organize yet unsupported data -->

# Preparing a BIDS dataset by hand and from scratch

This a simple recipe to convert your neuroimaging data into a valid BIDS
dataset.

**table of content**

<!-- Add HTML hyperlinks -->

- [Ingredients](#Ingredients-&-tools)
- [Recipe](#Recipe)
- [Useful links](#Useful-links)

<br>

<details><summary> <b>Click me...</b> </summary><br>

... to see what I hide !!!

<center>
<a href="https://twitter.com/RemiGau/status/1115513296134778880" target="_blank">
    <img src="https://pbs.twimg.com/media/D3sYRfhWkAAlevT?format=jpg&name=small" width="500" />
</a>
</center>

</details>

<br>

## Ingredients & tools

Get them fresh from your local ~~market~~:

- MRI scanner 🧲
- EEG amplifier 🌩
- MEG squid [🦑](https://theupturnedmicroscope.com/comic/squid/)
- ...

<br>

<details><summary> <b> 🧠 some <code>source</code> data to be converted into BIDS </b> </summary><br>
    <p>
        We will work with the <a href="https://www.fil.ion.ucl.ac.uk/spm/data/mmfaces/" target="_blank">multi-modal face dataset from SPM</a>.
    </p>
    <p>
        This dataset contains EEG, MEG and fMRI data on the same subject within the same paradigm.
    </p>
    <p>
        Very often MRI source data will be in a DICOM format and will require to be converted.
        Here the MRI data is in "3D" Nifti format <code>.hdr/.img</code> and
        we will need to change that to a "4D" Nifti <code>.nii</code> format.
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
    <p>
      For the MRI data we will be using some of the `SPM` built-in functions.
    </p>
</details>

<br>

## Recipe

### 1. Preheat the oven: creating folders

- Create a `raw` folder to host your BIDS data and inside it create:

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

<br>

### 2. Starters: converting the anatomical MRI file

- In Matlab launch SPM: `spm fmri`.
- In SPM:

  - `Batch --> SPM --> Utils --> 3D to 4D File conversion`
  - select the `*.img` file to convert
  - keep track of what you did by saving the batch in `code/conversion`
  - run the batch

#### a. Cooking is not just about the taste, it is also about how things look: naming files

- Move the `.nii` file you have just created into `sub-01/ses-mri/anat`.
- Give this file a valid BIDS name.

---

BIDS filenames are composed of:

- `extension`
- `suffix` preceded by a `_`
- `entity`-`label` pairs separated by `_`

So a BIDS filename can look like:

```bash
  entity1-label1_entity2-label2_suffix.extension
```

`entities` and `labels` can only contain letters and / or numbers.

For a given suffix, some entities are `required` and some others are
`[optional]`.

Entity-label pairs have a specific order in which they must appear in a
filename.

- [filename template](https://bids-specification.readthedocs.io/en/stable/04-modality-specific-files/01-magnetic-resonance-imaging-data.html#anatomy-imaging-data)
- [entity table](https://bids-specification.readthedocs.io/en/stable/99-appendices/04-entity-table.html)

#### b. Taste your dish while you prepare it: using the BIDS validator

Try it directly in your
[browser](https://bids-standard.github.io/bids-validator/).

<details><summary> 🖋 Install it locally </summary><br>
    <ul>
        <li><a href="https://nodejs.org" target="_blank">Install Node.js (at least version 12.12.0)</a></li>
        <li>Update <code>npm</code> to be at least version 7 (<code>npm install --global npm@^7</code>)</li>
        <li>From a terminal run <code>npm install -g bids-validator</code></li>
        <li>Run <code>bids-validator</code> to start validating datasets.</li>
    </ul>
    See the full instruction <a href="https://www.npmjs.com/package/bids-validator#quickstart" target="_blank">here.</a>
</details>

#### c. Season to taste: adding missing files

- `README`
- `dataset_description.json`

You can get content for those files from:

- from the [BIDS specification](https://bids-specification.readthedocs.io)
- the BIDS starter
  [templates](https://github.com/bids-standard/bids-starter-kit/tree/main/templates)

#### d. Icing on the cake: adding extra information

- Add a participants `partipants.tsv`

- can use excel to create

#### e. BIDS is data jam: let's preserve some

```bash
datalad create --force -c text2git .
datalad save -m 'initial commit'
```

<br>

### 3. Main course: converting the functional MRI files

2 runs

convert img --> nii

use validator & add missing file

.json --> taskname

events.tsv --> script

inheritance principle --> single json

### 3. Dessert: converting the functional MRI files

<!--
- Defacing
- MRIQC
- Things to improve
-->

<br>

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
  - [reproducibility.stanford.edu](https://reproducibility.stanford.edu/bids-tutorial-series-part-1a/)
  - [fieldtrip](https://www.fieldtriptoolbox.org/example/bids_mous/)
- [Conversion tools](https://bids.neuroimaging.io/benefits.html#converters)
- [Datalad handbook](http://handbook.datalad.org/en/latest/index.html)
- [GIN](https://gin.g-node.org/)

---
