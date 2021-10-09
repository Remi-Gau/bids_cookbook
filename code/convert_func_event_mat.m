function convert_func_event_mat(input_file, output_file, func_info)
    %
    % Simple function to convert events .mat files to .tsv
    %
    % Requires BIDS matlab
    %
    % (C) Copyright 2021 Remi Gau

    if nargin<1
       input_file = spm_select(1, 'mat', 'select the .mat file to convert');
    end
    if nargin<2
        output_file = fullfile(pwd, 'events.tsv');
    end
    if nargin<3
        func_info.repetition_time = 2;
    end

    load(input_file, 'names', 'onsets', 'durations');

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

    onset_column = func_info.repetition_time * onset_column;

    tsv_content = struct('onset', onset_column, ...
                         'duration', duration_column, ...
                         'trial_type', {cellstr(trial_type_column)});

    bids.util.tsvwrite(output_file, tsv_content);

end
