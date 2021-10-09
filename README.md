<!-- TODO
- conversion script for MEG events
- link to BEPs have a look and contribute
- use BEPs to organize yet unsupported data -->

<h1 style="width: 120%"> Preparing a BIDS dataset by hand and from scratch </h1>

<center>
<h3 style="color:red;">
  ⚠️ Note that this is purely for learning purposes and it is NOT recommended to BIDSify real datasets by hand . ⚠️
</h3>
</center>

<h2 id="TOC"> Table of content </h2>

- [Ingredients](#ingredients-and-tools)
- [Recipe](#recipe)
- [Useful links](#useful-links)

<details><summary> <b>CLICK ME</b> </summary><br>

... to see what I hide !!!

<center>
<a href="https://twitter.com/RemiGau/status/1115513296134778880" target="_blank">
    <img src="https://pbs.twimg.com/media/D3sYRfhWkAAlevT?format=jpg&name=small" width="500" />
</a>
</center>

</details>

<br>

## Ingredients and tools

Get them fresh from your local ~~market~~:

- MRI scanner 🧲
- EEG amplifier 🌩
- MEG squid [🦑](https://theupturnedmicroscope.com/comic/squid/)
- ...

<details><summary> <b> 🧠 some <code>source</code> data to be converted into BIDS </b> </summary><br>
  <p>
    We will work with the
    <a href="https://www.fil.ion.ucl.ac.uk/spm/data/mmfaces/" target="_blank">
    multi-modal face dataset from SPM
    </a>.
  </p>
  <p>
      Very often MRI source data will be in a DICOM format and will require to be converted.
      Here the MRI data is in "3D" Nifti format <code>.hdr/.img</code> and
      we will need to change that to a "4D" Nifti <code>.nii</code> format.
  </p>
  <p>
    This dataset contains EEG, MEG and fMRI data on the same subject within the same paradigm.
    We also extracted some of the information about the data from the SPM manual
    and put it into the <code>source/README.md</code>.
  </p>
  <p>
    Similarly when you have DICOM data, it is usually a good idea
    to keep the PDF of MRI acquisition parameters with your source data.
  </p>
</details>

<details><summary> <b> 🖋 a text editor </b> </summary><br>
    Several common options top choose from:
    <ul>
        <li><a href="https://code.visualstudio.com" target="_blank">Visual Studio code</a></li>
        <li><a href="https://www.sublimetext.com/" target="_blank">Sublime</a></li>
        <li><a href="https://atom.io/" target="_blank">Atom</a></li>
        <li>Notepad does not really count.</li>
    </ul>
</details>

<details><summary> <b> ♻ some format conversion tools </b> </summary><br>
    <p>
      For the MRI data we will be using some of the SPM built-in functions
      to convert Nifti files into the proper format.
    </p>
</details>

<details>
  <summary> <b>
    <img  src="https://raw.githubusercontent.com/datalad/artwork/master/logos/logo_solo.svg"
          height="14"
          style="padding: 0; margin: 0"/>
    [OPTIONAL] Datalad to version control your data
  </b> </summary> <br>

  <p>
    You can follow the installation instruction in the
    <a href="http://handbook.datalad.org/en/latest/intro/installation.html" target="_blank">
    Datalad handbook.
    </a>
  </p>
</details>

<details><summary> <b> 📥 [OPTIONAL] BIDS validator </b> </summary><br>
  <ul>
      <li>Install <a href="https://nodejs.org" target="_blank">Node.js</a> (at least version 12.12.0).</li>
      <li>Update <code>npm</code> to be at least version 7 (<code>npm install --global npm@^7</code>)</li>
      <li>From a terminal run <code>npm install -g bids-validator</code></li>
      <li>Run <code>bids-validator</code> to start validating datasets.</li>
  </ul>
  See the full instruction <a href="https://www.npmjs.com/package/bids-validator#quickstart" target="_blank">here.</a>
</details>

<br>

## Recipe

### 1. Preheat the oven: creating folders

- Create a `raw` folder to host your BIDS data and inside it create:

  - a `sourcedata` folder and put your `source` data in it
  - a `code/conversion` folder and put this `README.md` in it
  - a subject folder: `sub-01`
    - with session folder: `ses-mri`
      - with an `anat` folder for the structural MRI data
      - with an `func` folder for the functional MRI data

<details><summary> <b>By now you should have this.</b> </summary><br>
  <pre>
  └── raw
      ├── code
      │   └── conversion
      ├── sourcedata
      │   ├── multimodal_fmri
      │   └── multimodal_smri
      └── sub-001
          └── ses-mri
              ├── anat
              └── func
  </pre>
</details>

<br>

### 2. Starters: converting the anatomical MRI file

- In Matlab launch SPM: `spm fmri`.
- In SPM:

  - use the SPM 3D to 4D module:
    ```
      Batch --> SPM --> Utils --> 3D to 4D File conversion
    ```
  - select the `*.img` file to convert
  - keep track of what you did by saving the batch in `code/conversion`
  - run the batch

#### a. Cooking is not just about the taste, it is also about how things look: naming files

- Move the `.nii` file you have just created into `sub-01/ses-mri/anat`.
- Give this file a valid BIDS filename.

<details><summary> ✅ Valid BIDS filenames </summary><br>

  <ul>
    <li>
      BIDS filenames are composed of:
      <ul>
        <li><code>extension</code></li>
        <li><code>suffix</code> preceded by a <code>_</code></li>
        <li><code>entity-label</code> pairs separated by a <code>_</code></li>
      </ul>
    </li>
    <li>
      So a BIDS filename can look like: <code>entity1-label1_entity2-label2_suffix.extension</code>
    </li>
    <li>
      <code>entities</code> and <code>labels</code> can only contain letters and / or numbers.
    </li>
    <li>
      For a given suffix, some entities are <code>required</code> and some others are <code>[optional]</code>.
    </li>
    <li>
      <code>entity-label</code> pairs pairs have a specific order in which they must appear in filename.
    </li>
  </ul>

</details>

In case you do not remember which suffix to use and which entities are required
or optional, the BIDS specification has:

- [filename templates](https://bids-specification.readthedocs.io/en/stable/04-modality-specific-files/01-magnetic-resonance-imaging-data.html#anatomy-imaging-data)
  at the beginning of the section for each imaging modality,
- a summary
  [entity table](https://bids-specification.readthedocs.io/en/stable/99-appendices/04-entity-table.html).

#### b. Taste your dish while you prepare it: using the BIDS validator

Try it directly in your
<a href="https://bids-standard.github.io/bids-validator/" target="_blank">browser.</a>

#### c. Season to taste: adding missing files

- `README`
- `dataset_description.json`

You can get content for those files from:

- from the [BIDS specification](https://bids-specification.readthedocs.io) (use
  the search bar)
- the BIDS starter
  [templates](https://github.com/bids-standard/bids-starter-kit/tree/main/templates)

> Suggestion:
>
> Add the "table" output of the BIDS validator to your README to give a quick
> overview of the content of your dataset.

<details><summary> 🚨 About JSON files </summary><br>
  <p>JSON files are text files to store <code>key-value</code> pairs.</p>

  <p>
    If your editor cannot help you format them properly , you can always use the
    <a href="https://jsoneditoronline.org/" target="_blank"> online editor.</a>
  </p>

  <p>
    More information on how read and write JSON files is available on the
    <a  href="https://github.com/bids-standard/bids-starter-kit/wiki/Metadata-file-formats#json-files"
        target="_blank">
      BIDS stater kit.
    </a>
  <p>

  <pre>
    JSON CONTENT EXAMPLE:

    {
      "key": "value",
      "key2": "value2",
      "key3": {
        "subkey1": "subvalue1"
      },
      "array": [ 1, 2, 3 ],
      "boolean": true,
      "color": "gold",
      "null": null,
      "number": 123,
      "object": {
        "a": "b",
        "c": "d"
      },
      "string": "Hello World"
    }
  </pre>
</details>

#### d. Icing on the cake: adding extra information

- Add `T1w.json` file.
- Add a participants `participants.tsv`. You can use excel or google sheet to
  create them.

<details><summary> 🚨 About TSV files </summary><br>
  <p>
    A Tab-Separate Values (TSV) file is a text file
    where tab characters (<code>\t</code>) separate fields that are in the file.
  </p>

  <p>
    It is structured as a table, with each column representing a field of interest,
    and each row representing a single datapoint.
  </p>

  <p>
    More information on how read and write TSV files is available on the
    <a href="https://github.com/bids-standard/bids-starter-kit/wiki/Metadata-file-formats#tsv-files"
      target="_blank"> BIDS stater kit
    </a>
  </p>

  <pre>
    TSV CONTENT EXAMPLE:

    participant_id\tage\tgender
    sub-01\t34\tM
  </pre>
</details>

#### e. BIDS is data jam: let's preserve some

**[OPTIONAL]**

- Create a Datalad dataset
- make a commit when you have a valid dataset to use as a checkpoint.

```bash
datalad create --force -c text2git .
datalad save -m 'initial commit'
```

<br>

### 3. Main course: converting the functional MRI files

- Convert the 2 runs of made of 3D series of `*.img` into 2 single 4D `*.nii`
  images by using the same SPM module used for the anatomical conversion.
- Make sure to use enter the repetition time in the `interscan interval`.
- Give the output files valid BIDS filenames. You will need to use `task` and
  the `run` entities.
- Use the BIDS validator and any eventual missing file (like `*_bold.json`
  file).

<!-- TODO -->

- Create `events.tsv` --> function
- Remove duplicate `json` files ("inheritance principle")

### 4. Dessert: defacing, quality control, upload your data to GIN

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

<button><a href="#TOC">back to the top</a></button>
