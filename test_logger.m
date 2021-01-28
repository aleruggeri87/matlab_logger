L=logger('the_log.txt',[],'TEST LOG',@logger_parser);
L.comment('ciao');
test(L)
test2(L)
test3(L)
L.close()
%%

function test(obj)
    obj.log('a');
end

function test2(obj)
    obj.log(2);
end

function test3(obj)
    obj.log(2, 'ciao', [2 3]);
end