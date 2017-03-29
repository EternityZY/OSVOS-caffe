% This function builds all the MEX files needed.
% Dependencies needed to build: Boost C++ libraries (http://www.boost.org)
%
% The code contains C++11 functionality, so you have to use a compiler that
% supports the flag -std=c++11.C
% Some help on how to do it in: http://jponttuset.github.io/matlab2014-mex-flags/
% ------------------------------------------------------------------------
function build()
% Check that 'osvos_root' has been set
if ~exist(osvos_root,'dir')
    error('Error building OSVOS, try updating the value of osvos_root in the file "osvos_root.m"')
end

%% Include the generic paths and files to compile
include{1} = fullfile(osvos_root, 'src', 'misc');  % To get matlab_multiarray.hpp
if (strcmp(computer(),'PCWIN64') || strcmp(computer(),'PCWIN32'))
    include{2} = 'C:\Program Files\boost_1_55_0';  % Boost libraries (change it if necessary)
else
    include{2} = '/opt/local/include/';  % Boost libraries (change it if necessary)
end
include{3} = fullfile(osvos_root, 'src', 'external','piotr_toolbox'); % To build Piotr toolbox
include{4} = fullfile(osvos_root, 'src', 'external'); % To build Piotr toolbox

include_str = '';
for ii=1:length(include)
    include_str = [include_str ' -I''' include{ii} '''']; %#ok<AGROW>
end

build_file{1}     = fullfile(osvos_root, 'src', 'misc', 'mex_intersect_hierarchies.cpp');
build_file{end+1} = fullfile(osvos_root, 'src', 'misc', 'mex_ucm2hier.cpp');
build_file{end+1} = fullfile(osvos_root, 'src', 'misc', 'mex_ucm_align.cpp');
build_file{end+1} = fullfile(osvos_root, 'src', 'misc', 'mex_ucm_rescale.cpp');

%% Define the compiler
gcc_compiler = 'g++';
gcc_string = ['GCC=''' gcc_compiler ''' '];

%% Build everything
if ~exist(fullfile(osvos_root, 'lib'),'dir')
    mkdir(fullfile(osvos_root, 'lib'))
end
            
for ii=1:length(build_file)
    eval(['mex ' gcc_string '''' build_file{ii} ''' -outdir ''' fullfile(osvos_root, 'lib') '''' include_str])
end

%% Build piotr_toolbox files
eval(['mex ' gcc_string fullfile(osvos_root, 'src', 'external','piotr_toolbox',     'convConst.cpp') ' -outdir ' fullfile(osvos_root, 'lib') include_str])
eval(['mex ' gcc_string fullfile(osvos_root, 'src', 'external','piotr_toolbox',   'gradientMex.cpp') ' -outdir ' fullfile(osvos_root, 'lib') include_str])

%% Build BSR-related files
% 'ucm_mean_pb'
eval(['mex ' gcc_string fullfile(osvos_root, 'src', 'bsr', 'ucm_mean_pb.cpp') ' -outdir ' fullfile(osvos_root, 'lib')])
    
% 'mex_contour_sides'
eval(['mex ' gcc_string fullfile(osvos_root, 'src', 'bsr', 'mex_contour_sides.cpp') ' -outdir ' fullfile(osvos_root, 'lib'),...
            ' -I' fullfile(osvos_root,'src','external','BSR','include'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','concurrent','threads','child_thread.cc'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','concurrent','threads','runnable.cc'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','concurrent','threads','thread.cc'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','concurrent','threads','synchronization','synchronizables','synchronizable.cc'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','concurrent','threads','synchronization','synchronizables','unsynchronized.cc'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','lang','exceptions','ex_bad_cast.cc'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','lang','exceptions','ex_not_found.cc'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','lang','exceptions','ex_not_implemented.cc'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','lang','exceptions','ex_index_out_of_bounds.cc'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','lang','exceptions','ex_invalid_argument.cc'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','lang','exceptions','ex_null_pointer_dereference.cc'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','lang','exceptions','exception.cc'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','lang','exceptions','throwable.cc'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','lang','array.cc'),...                
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','random','generators','rand_gen_uniform.cc'),...     
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','random','sources','rand_source_default.cc'),...     
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','random','sources','rand_source.cc'),...     
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','random','sources','mersenne_twister_64.cc'),...     
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','random','sources','rand_source_64.cc'),...     
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','random','sources','system_entropy.cc'),...     
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','random','util','randperm.cc'),...     
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','matrices','matrix.cc'),...     
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','matrices','exceptions','ex_matrix_dimension_mismatch.cc'),...     
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','libraries','lib_image.cc'),...
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','libraries','lib_signal.cc'),...                     
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','math.cc'),...     
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','exact.cc'),...     
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','geometry','point_2D.cc'),...     
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','geometry','seg_intersect.cc'),...     
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','geometry','triangulation.cc'),...  
            '   ' fullfile(osvos_root,'src','external','BSR','src','math','geometry','triangle_2D.cc'),...  
            '   ' fullfile(osvos_root,'src','external','BSR','src','mlearning','clustering','clusterers','abstract','clusterer.cc'),...  
            '   ' fullfile(osvos_root,'src','external','BSR','src','mlearning','clustering','clusterers','abstract','weighted_clusterer.cc'),...  
            '   ' fullfile(osvos_root,'src','external','BSR','src','mlearning','clustering','clusterers','kmeans','basic_clusterer.cc'),...  
            ]);

%% Clear variables
clear build_file file1 file2 dep1 dep2 o_file1 o_file2 ii include include_str

%% Show message
disp('-- Successful compilation of OSVOS. Don''t forget to compile Caffe under osvos-caffe! Enjoy! --');

