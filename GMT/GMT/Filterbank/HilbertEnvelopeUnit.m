% HilbertEnvelopeUnit < ProcUnit
% Compute frame-by-frame Hilbert envelopes from FFT coefficients. Can
% provide log2 (nOutputs = 1) or both log2 and linearly-scaled values
% (nOutputs = 2).
%
% Input Ports:
%    #1  - FFT coefficient matrix (nFreq x nFrames)
%
% Output Ports:
%    #1  - log2 Hilbert envelopes (nCh x nFrames)
%   [#2] - linear Hilbert envelopes (nCh x nFrames)
%
% See also: hilbertEnvelopeFunc.m
% Copyright (c) 2012-2020 Advanced Bionics. All rights reserved.

classdef HilbertEnvelopeUnit < ProcUnit
    properties (SetObservable)
        outputOffset = 0;  % scalar offset added to all channel outputs; [log2] [0] Use with caution!
        outputLowerBound = 0;   % lower bound applied to output (after offset) [log2] [0]
        outputUpperBound = Inf; % lower bound applied to output (after offset) [log2] [Inf]
    end
    
    methods
        % function obj = ExtractEnvelopeUnit(parent, ID, nOutputs)
        % Input:
        %    nOutputs: 1 (log2) or 2 (log2 and linear)
        function obj = HilbertEnvelopeUnit(parent, ID, nOutputs)
            if nargin == 2
               nOutputs = 1;
            end
            assert(nOutputs == 1 || nOutputs == 2, 'nOutput must equal 1 or 2.');          
            obj = obj@ProcUnit(parent, ID, 1, nOutputs);
        end
        
        function run(obj)
            X = obj.getInput(1);

            if obj.outputCount == 1
                env = hilbertEnvelopeFunc(obj, X);
                obj.setOutput(1, env);
            elseif obj.outputCount == 2
                [env, envNoLog] = hilbertEnvelopeFunc(obj, X);
                obj.setOutput(1, env);
                obj.setOutput(2, envNoLog);
            end
        end
        
    end
end
