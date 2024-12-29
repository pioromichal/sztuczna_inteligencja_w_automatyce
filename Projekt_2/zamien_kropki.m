function zamien_kropki()
    yticks = get(gca, 'YTick');
    set(gca, 'YTickLabel', strrep(cellstr(num2str(yticks(:))), '.', ',')); 

    xticks = get(gca, 'XTick');
    set(gca, 'XTickLabel', strrep(cellstr(num2str(xticks(:))), '.', ','));

    titleHandle = get(gca, 'Title');
    titleText = get(titleHandle, 'String');
    set(titleHandle, 'String', strrep(titleText, '.', ','));
end