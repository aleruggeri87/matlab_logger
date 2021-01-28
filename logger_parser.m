function logger_parser(log, varargin)
    va=varargin{1};
    fun_name=log.getCallerName(4);
    thedata='';
    skip=false;
    switch fun_name
        case 'test'
            thedata=va{1};
        case 'test2'
            thedata=num2str(va{1});
        case 'test3'
            thedata=[num2str(va{1}) ' - ' ...
                va{2} num2str(va{3}(1) + va{3}(2))]; % 2, 'ciao', [2 3]
        otherwise
            if log.level>=log.LOG_TRACE
                skip = true;
            end
    end
    if ~skip
        log.report(['(' fun_name ') ' thedata]);
    end
end