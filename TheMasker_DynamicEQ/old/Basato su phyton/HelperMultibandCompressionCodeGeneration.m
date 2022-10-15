function HelperMultibandCompressionCodeGeneration
%HELPERMULTIBANDCOMPRESSIONCODEGENERATION Code generation for multiband
%compression example
%
% Run this function to generate a MEX file for the
% HelperMultibandCompressionSim function. 
%
% This function is only in support of
% MultibandDynamicRangeCompressionExample. It may change in a future
% release.

% Copyright 2014-2018 The MathWorks, Inc.

% Parameters to be tuned
%  Ratio threshold AttackTime ReleaseTime for four compressors
ParamStruct.TuningValues = [10 -10 .02 .02 10 -10 .02 .02 10 -10 .02 .02 10 -10 .02 .02 0.0];
ParamStruct.ValuesChanged = false;
ParamStruct.Reset = false;
ParamStruct.Pause = false;
ParamStruct.Stop  = false;

codegen -report HelperMultibandCompressionSim -args {ParamStruct} 

