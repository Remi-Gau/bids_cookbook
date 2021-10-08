---
tags: BIDS
---

# How to cook a BIDS dataset by hand and from <!-- scratch -->

This a simple recipe to convert your neuroimaging data into a valid BIDS
dataset.

**table of content**

- [Ingredients](#Ingredients)
- Recipe
- Useful links

<br>

---

<details><summary> <b>Click me...</b> </font> </summary><br>

... to see what I hide !!!

<a href="https://twitter.com/RemiGau/status/1115513296134778880" target="_blank">
    <img src="https://pbs.twimg.com/media/D3sYRfhWkAAlevT?format=jpg&name=small" width="500" />
</a>

</details>

<br>

---

## Ingredients & tools

Get them fresh from your local ~~market~~:

- MRI scanner 🧲
- EEG amp 🌩
- MEG [:octopus:](https://theupturnedmicroscope.com/comic/squid/)
- ...

<br>

<details><summary> <b> 🧠 some <code>source</code> data to be converted into BIDS </b> </font> </summary><br>
    We will work with the <a href="https://www.fil.ion.ucl.ac.uk/spm/data/mmfaces/" target="_blank">multi-modal face dataset from SPM</a>.
    <br>
    This dataset contains EEG, MEG and fMRI data on the same subject within the same paradigm. 
    <br>
    Very often MRI source ata will be in a DICOM format and will required to be converted.
    Here the MRI data is in 3D Nifti Nifti  format <code>.hdr/.img</code> and 
    we will need to change that to a 4D Nifti <code>.nii</code> format
</details>

<br>

<details><summary> <b> 🖋 a text editor </b> </font> </summary><br>
    Several common options top choose from:
    <ul>
        <li><a href="https://code.visualstudio.com" target="_blank">visual studio code</a></li>
        <li><a href="https://www.sublimetext.com/" target="_blank">sublime</a></li>
        <li><a href="https://atom.io/" target="_blank">atom</a></li>
        <li>Notepad does not count.</li>
    </ul>
</details>

<br>

<details><summary> <b> ♻ some format conversion tools </b> </font> </summary><br>
    For the MRI data we will be using some of the SPM built in functions.
</details>

<br>

---

## Recipe

1. Creating folders

> A clean kitchen set up is essential for successful meal.

Create a `raw` folder to host your BIDS data and inside it create:

- a `sourcedata` folder and put your `source` data in it
- a `code/conversion` folder and put this README in it
- a subject folder: `sub-01`
  - with session folder: `ses-mri`
    - with an `anat` folder for the structural MRI data
    - with an `anat` folder for the functional MRI data

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

2. Converting the MRI anatomical file

in matlab launch SPM
Batch --> SPM --> Utils --> 3D to 4D File conversion
save the batch in `code/conversion`

3. Naming files

> Cooking is not just about the taste, it is also about how things look.

extension
suffix
entity-label pairs

filename template
entity table

4. Using the validator

> Taste your dish while you prepare it!

5. Adding missing files

dataset_description.json

6. Saving a first version

7. 





- Collect and convert MRI data from DICOM to NIFTI
- Collect and rename the CTF MEG datasets
- Collect the MEG coregistered anatomical MRIs
- Create the sidecar files for each dataset
- Create the general sidecar files


- Defacing
- MRIQC
- Things to improve

<br>

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

<br>

---
