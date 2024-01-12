function swappedCategories = swapMostFrequentCategory(categoricalVar, categories)

% Count the occurrences of each category
categoryCounts = countcats(categorical(categoricalVar));

% Find the category with the maximum count
[~, maxIndex] = max(categoryCounts);

if maxIndex ~=1
    foo = categories{maxIndex};
    categories{maxIndex} = categories{1};
    categories{1} = foo;
end
swappedCategories = categories;
end