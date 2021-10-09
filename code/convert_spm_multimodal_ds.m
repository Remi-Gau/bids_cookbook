function convert_spm_multimodal_ds()
  %
  % Converts the multimodal dataset from SPM and to BIDS
  %
  % Source: https://www.fil.ion.ucl.ac.uk/spm/data/mmfaces/
  %
  % Requires BIDS matlab
  %
  % Script adapted from its counterpart for MoAE
  % <https://www.fil.ion.ucl.ac.uk/spm/download/data/MoAEpilot/MoAE_convert2bids.m>
  %
  % (C) Copyright 2021 Remi Gau

  % TODO
  % - HED tags

  download = false;

  subject_label = '01';

  task_name = 'FaceSymmetry';

  func.nb_slices = 32;
  func.repetition_time = 2;
  func.discarded_volumes = 5;
  func.manufacturer = 'Siemens';
  func.model = 'TIM Trio';
  func.field_strength = 3;

  anat.manufacturer = 'Siemens';
  anat.model = 'Sonata';
  anat.field_strength = 1.5;

  opt.indent = ' ';

  % URL of the data set to download

  working_directory = fileparts(mfilename('fullpath'));
  input_dir = fullfile(working_directory, '..', 'source');
  output_dir = fullfile(working_directory, '..', 'raw');

  % clean previous runs
  try
    rmdir(output_dir, 's');
  catch
  end

  spm_mkdir(output_dir);

  downwload_data(input_dir, working_directory, download);

  %% Create ouput folder structure
  spm_mkdir(output_dir, ['sub-' subject_label], {'ses-mri'}, {'anat', 'func'});
  spm_mkdir(output_dir, ['sub-' subject_label], {'ses-eeg'}, {'eeg'});
  spm_mkdir(output_dir, ['sub-' subject_label], {'ses-meg'}, {'meg'});

  convert_anat(input_dir, output_dir, opt, subject_label, anat);
  convert_func(input_dir, output_dir, opt, subject_label, task_name, func);
  convert_eeg(input_dir, output_dir, opt, subject_label, task_name);
  convert_meg(input_dir, output_dir, opt, subject_label, task_name);

  %% And everything else
  create_readme(output_dir);
  create_changelog(output_dir);
  create_datasetdescription(output_dir);

  fprintf(1, '\n');

end

function downwload_data(input_dir, working_directory, download)
  if download
    try
      rmdir(input_dir, 's');
    catch
    end

    spm_mkdir(fullfile(working_directory, 'inputs'));

    %% Get data
    fprintf('%-10s:', 'Downloading dataset...');
    urlwrite(URL, 'face_rep.zip');
    fprintf(1, ' Done\n\n');

    fprintf('%-10s:', 'Unzipping dataset...');
    unzip('face_rep.zip');
    movefile('face_rep', fullfile(working_directory, 'inputs', 'source'));
    fprintf(1, ' Done\n\n');
  end
end

function convert_anat(input_dir, output_dir, opt, subject_label, anat)

  fprintf(1, '\nconverting anat');

  file = struct('suffix', 'T1w', ...
                'ext', '.nii', ...
                'modality', 'anat', ...
                'use_schema', true, ...
                'entities', struct('sub', subject_label, ...
                                   'ses', 'mri'));
  bidsFile = bids.File(file);

  anat_input_dir = fullfile(input_dir, 'multimodal_smri', 'sMRI');

  % change from nifti (.hdr + .img) to nifti (.nii)
  anat_hdr = spm_vol(fullfile(anat_input_dir, 'smri.img'));
  anat_data = spm_read_vols(anat_hdr);
  anat_hdr.fname = fullfile(output_dir, bidsFile.relative_pth, bidsFile.filename);
  spm_write_vol(anat_hdr, anat_data);

  json_content = struct('Manufacturer', anat.manufacturer, ...
                        'ManufacturersModelName', anat.model, ...
                        'MagneticFieldStrength', anat.field_strength);
  bids.util.jsonencode(fullfile(output_dir, 'T1w.json'), ...
                       json_content);
end

function convert_func(input_dir, output_dir, opt, subject_label, task_name, func)

  fprintf(1, '\nconverting func');

  func_input_dir = fullfile(input_dir, 'multimodal_fmri', 'fMRI');

  for iRun = 1:2
    func_files = spm_select('FPList', ...
                            fullfile(func_input_dir, ['Session' num2str(iRun)]), ...
                            '^fMETHODS.*\.img$');

    file = struct('suffix', 'bold', ...
                  'ext', '.nii', ...
                  'modality', 'func', ...
                  'use_schema', true, ...
                  'entities', struct('sub', subject_label, ...
                                     'ses', 'mri', ...
                                     'task', task_name, ...
                                     'run', num2str(iRun)));
    bidsFile = bids.File(file);

    % convert 3D to 4D and change from nifti (.hdr + .img) to nifti (.nii)
    spm_file_merge( ...
                   func_files, ...
                   fullfile(output_dir, bidsFile.relative_pth, bidsFile.filename), ...
                   0, ...
                   func.repetition_time);

    delete(fullfile(output_dir, ...
                    bidsFile.relative_pth, ...
                    strrep(bidsFile.filename, '.nii', '.mat')));
  end

  create_bold_json(output_dir, task_name, opt, func);
  create_events_tsv_file(func_input_dir, ...
                         fullfile(output_dir, bidsFile.relative_pth), ...
                         subject_label, ....
                         task_name, ...
                         func);
end

function convert_eeg(input_dir, output_dir, opt, subject_label, task_name)

  fprintf(1, '\nconverting eeg');

  eeg_input_dir = fullfile(input_dir, 'multimodal_eeg', 'EEG');

  eeg_files = spm_select('FPList', eeg_input_dir, '^.*.bdf$');
  for iRun = 1:size(eeg_files, 1)

    file = struct('suffix', 'eeg', ...
                  'ext', '.bdf', ...
                  'modality', 'eeg', ...
                  'use_schema', true, ...
                  'entities', struct('sub', subject_label, ...
                                     'ses', 'eeg', ...
                                     'task', task_name, ...
                                     'run', num2str(iRun)));
    bidsFile = bids.File(file);

    copyfile(eeg_files(iRun, :), fullfile(output_dir, bidsFile.relative_pth, bidsFile.filename));

  end

end

function convert_meg(input_dir, output_dir, opt, subject_label, task_name)

  fprintf(1, '\nconverting meg');

  % TODO
  % change this because .ds folders has files that should be renamed too

  meg_input_dir = fullfile(input_dir, 'multimodal_meg', 'MEG');

  [~, meg_dirs] = spm_select('FPList', meg_input_dir, '^.*.ds$');
  for iRun = 1:size(meg_dirs, 1)

    file = struct('suffix', 'meg', ...
                  'ext', '.ds', ...
                  'modality', 'meg', ...
                  'use_schema', true, ...
                  'entities', struct('sub', subject_label, ...
                                     'ses', 'meg', ...
                                     'task', task_name, ...
                                     'run', num2str(iRun)));
    bidsFile = bids.File(file);

    copyfile(meg_dirs(iRun, :), fullfile(output_dir, bidsFile.relative_pth, bidsFile.filename));

  end

end

function create_events_tsv_file(input_dir, output_dir, subject_label, task_name, func)

  fprintf(1, '\ncreating func events');

  for iRun = 1:2
    load(fullfile(input_dir, ['trials_ses' num2str(iRun) '.mat']), ...
         'names', 'onsets', 'durations');

    onset_column = [];
    duration_column = [];
    trial_type_column = [];

    for iCondition = 1:numel(names)
      onset_column = [onset_column; onsets{iCondition}']; %#ok<*USENS>
      duration_column = [duration_column; durations{iCondition}']; %#ok<*AGROW>
      trial_type_column = [trial_type_column; repmat( ...
                                                     names(iCondition), ...
                                                     size(onsets{iCondition}', 1), 1)];
    end

    % sort trials by their presentation time
    [onset_column, idx] = sort(onset_column);
    duration_column = duration_column(idx);
    trial_type_column = trial_type_column(idx, :);

    onset_column = func.repetition_time * onset_column;

    tsv_content = struct('onset', onset_column, ...
                         'duration', duration_column, ...
                         'trial_type', {cellstr(trial_type_column)});

    file = struct('suffix', 'events', ...
                  'modality', 'func', ...
                  'use_schema', true, ...
                  'ext', '.tsv', ...
                  'entities', struct('sub', subject_label, ...
                                     'ses', 'mri', ...
                                     'task', task_name, ...
                                     'run', num2str(iRun)));
    bidsFile = bids.File(file);

    bids.util.tsvwrite(fullfile(output_dir, bidsFile.filename), ...
                       tsv_content);

  end

end

function create_readme(output_dir)

  fprintf(1, '\ncreating README');

  rdm = {
         ' ___ ____ __ __'
         '/ __)( _ \( \/ ) Statistical Parametric Mapping'
         '\__ \ )___/ ) ( Wellcome Centre for Human Neuroimaging'
         '(___/(__) (_/\/\_) https://www.fil.ion.ucl.ac.uk/spm/'

         ''
         ' Face repetition example event-related fMRI dataset'
         '________________________________________________________________________'
         ''
         'Summary'
         ''
         ' 7 Files, 215.74MB'
         ' 1 - Subject'
         ' 1 - Session'
         ''
         'Available Tasks'
         ''
         'FaceSymmetry'
         ''
         'Available Modalities'
         ''
         ' bold'
         ' T1w'
         ' events'
         ''
         ''
         ''
         'Experimental design:'};

  % TODO
  % use spm_save to actually write this file?
  fid = fopen(fullfile(output_dir, 'README'), 'wt');
  for i = 1:numel(rdm)
    fprintf(fid, '%s\n', rdm{i});
  end
  fclose(fid);

end

function create_changelog(output_dir)

  fprintf(1, '\ncreating CHANGES');

  cg = {'1.0.1 2021-??-??', ' - BIDS version.', ...
        '1.0.0 ????-??-??', ' - Initial release.'};
  fid = fopen(fullfile(output_dir, 'CHANGES'), 'wt');

  for i = 1:numel(cg)
    fprintf(fid, '%s\n', cg{i});
  end
  fclose(fid);

end

function create_datasetdescription(output_dir)

  fprintf(1, '\ncreating dataset_decription');

  descr = struct( ...
                 'BIDSVersion', '1.6.0', ...
                 'Name', 'spm multimodal dataset', ...
                 'Authors', {{ ...
                              'Rik Henson', ...
                              '???'}}, ...
                 'ReferencesAndLinks', ...
                 {{'https://www.fil.ion.ucl.ac.uk/spm/data/mmfaces/', ...
                   '???', ...
                   'doi:???'}} ...
                );

  bids.util.jsonencode(fullfile(output_dir, 'dataset_description.json'), ...
                       descr);

end

function create_bold_json(output_dir, task_name, opt, func)

  task = struct('Manufacturer', func.manufacturer, ...
                'ManufacturersModelName', func.model, ...
                'MagneticFieldStrength', func.field_strength, ...
                'RepetitionTime', func.repetition_time, ...
                'NumberOfVolumesDiscardedByUser', func.discarded_volumes, ...
                'TaskName', task_name, ...
                'TaskDescription', '???');

  bids.util.jsonencode(fullfile(output_dir, ...
                                ['task-' strrep(task_name, ' ', '') '_bold.json']), ...
                       task);

end
