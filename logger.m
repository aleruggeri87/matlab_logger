classdef logger < handle
    properties
        file_handle = NaN;
        manifest = 'MATLAB LOGGER';
        log=@logger.NOP;
    end
    
    properties(Dependent)
        level;
    end
    
    properties(Access=private)
        level_;
    end
    
    properties (Constant)
        LOG_OFF = 0;
        LOG_FATAL = 10;
        LOG_ERR = 20;
        LOG_WARN = 30;
        LOG_INFO = 40;
        LOG_DEBUG = 50;
        LOG_TRACE = 60;
        LOG_ALL = 100;
    end
    
    properties (Access = private)
        dataParserFunct;
    end
    
    methods
        function obj=logger(logPath, level, manifest, parser)
            if nargin >= 1 && ~isempty(logPath)
                obj.open(logPath);
            end
            if nargin >= 2 && ~isempty(level)
                obj.level=level;
            else
                obj.level=obj.LOG_INFO;
            end
            if nargin >= 3
                obj.manifest=manifest;
            end
            if nargin >= 4
                obj.dataParserFunct=parser;
            end
        end
        
        function delete(obj)
            obj.close();
        end
        
        function open(obj, logPath)
            if strcmpi(logPath, 'console')
                obj.file_handle=1;
            else
                obj.file_handle=fopen(logPath, 'a');
            end
            obj.log=@obj.data;
            obj.addTime();
            fprintf(obj.file_handle, ...
                '=== %s ===\n', obj.manifest);
        end
        
        function tf=active(obj)
            tf = ~isnan(obj.file_handle);
        end
        
        function comment(obj, message)
            obj.addTime();
            fprintf(obj.file_handle, ['### ' message '\n']);
        end
        
        function report(obj, message)
            obj.addTime();
            fprintf(obj.file_handle, [message '\n']);
        end
        
        function close(obj)
            if ~isnan(obj.file_handle)
                if obj.file_handle == 1
                    if isempty(find(fopen('all')==1, 1))
                        return;
                    end
                end
                fclose(obj.file_handle);
                obj.file_handle=NaN;
                obj.log=@logger.NOP;
            end
        end
        
        function set.level(obj,level)
            if level >= obj.LOG_OFF && level <= obj.LOG_ALL
                obj.level_=level;
            else
                error('Invalid log level');
            end
            if obj.active
                obj.addTime();
                fprintf(obj.file_handle, '=== LEVEL %0.f ===\n', obj.level);
            end
        end
        
        function val=get.level(obj)
            val=obj.level_;
        end
    end
    
    methods(Access=private)
        function addTime(obj)
            fprintf(obj.file_handle, [datestr(now,'HH:MM:SS.FFF') ' ']);
        end
        
        function data(obj, varargin)
            obj.dataParserFunct(obj, varargin);
        end
    end
    
    methods(Static, Access=private)
        function NOP(varargin)
        end
    end
    
    methods(Static)
        function name=getCallerName(skip_levels, strip)
            st=dbstack(skip_levels);
            if isempty(st)
                name='Base';
            elseif nargin < 2 || strip
                s=regexp(st(1).name,'\.','split');
                name=s{end};
            else
                name=st(1).name;
            end
        end
        
        function c=u8toBase64(data_in)
            if isa(data_in,'uint8')
                c=char(org.apache.commons.codec.binary.Base64.encodeBase64(data_in))';
            else
                error('input must be a uint8 array')
            end
        end
        
        function a=base64toU8(str_in)
            if ischar(str_in)
                a=uint8(org.apache.commons.codec.binary.Base64.decodeBase64(uint8(str_in)));
            else
                error('input must be a string')
            end
        end
    end
end
