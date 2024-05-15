import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
#!pip install --upgrade colormaps
import colormaps as cmaps

# File to be uploaded
file_path = 'FreshData.csv'

# Read the CSV file into a DataFrame
df = pd.read_csv(file_path, encoding='utf-16', delimiter='\t')

# Function to calculate fractions
def calculate_fractions(column):
    yes_fraction = np.sum(column == 'Yes') / len(column)
    no_fraction = np.sum(column == 'No') / len(column)
    nan_fraction = np.sum(column == 'Not investigated') / len(column)
    return yes_fraction, no_fraction, nan_fraction

# Prepare data for stacked bar plots for Study 2 Hypotheses 1 to 4
def prepare_data_for_study2_hypothesis(hypothesis_num):
    df_filtered = df[df['Study'] == 'Study 2']
    hypothesis_prefix = f'Study 2 Hypothesis {hypothesis_num} Participant '
    fractions = {}
    for i in range(1, 11):
        hypothesis = f'{hypothesis_prefix}{i}'
        if hypothesis in df_filtered.columns:
            fractions[hypothesis] = calculate_fractions(df_filtered[hypothesis])
        else:
            print(f"Warning: {hypothesis} not found in the DataFrame")
    return fractions

fractions1 = prepare_data_for_study2_hypothesis(1)
fractions2 = prepare_data_for_study2_hypothesis(2)
fractions3 = prepare_data_for_study2_hypothesis(3)
fractions4 = prepare_data_for_study2_hypothesis(4)

fractions_list = [fractions1, fractions2, fractions3, fractions4]

# Plotting stacked bar plots for Study 2 Hypotheses 1 to 4
def plot_stacked_bar(fractions, title, filename):
    categories = list(fractions.keys())
    yes_values = [fractions[hypothesis][0] for hypothesis in categories]
    no_values = [fractions[hypothesis][1] for hypothesis in categories]
    nan_values = [fractions[hypothesis][2] for hypothesis in categories]

    colormap_name = "tofino"
    cmap = getattr(cmaps, colormap_name)
    num_categories = 30
    colors = cmap(np.linspace(0, 1, num_categories))

    bar_width = 0.65
    fig, ax = plt.subplots(figsize=(15,6))
    ax.bar(categories, yes_values, bar_width, label='Yes', color=colors[20])
    ax.bar(categories, no_values, bar_width, bottom=yes_values, label='No', color=colors[4])
    ax.bar(categories, nan_values, bar_width, bottom=[i+j for i,j in zip(yes_values, no_values)], label='Not investigated', color=colors[12])

    ax.set_xlabel('Participants')
    ax.set_ylabel('Fraction')
    ax.set_title(title)
    ax.legend()
    plt.xticks(rotation=90)
    plt.savefig(filename, dpi=600)
    plt.show()

plot_stacked_bar(fractions1, 'Fractions of "Yes", "No", and "Not investigated" - Study 2 Hypothesis 1', 'Study2H1.png')
plot_stacked_bar(fractions2, 'Fractions of "Yes", "No", and "Not investigated" - Study 2 Hypothesis 2', 'Study2H2.png')
plot_stacked_bar(fractions3, 'Fractions of "Yes", "No", and "Not investigated" - Study 2 Hypothesis 3', 'Study2H3.png')
plot_stacked_bar(fractions4, 'Fractions of "Yes", "No", and "Not investigated" - Study 2 Hypothesis 4', 'Study2H4.png')

# Plot scatter plot for Study 2
results = np.zeros((4,10))

for i, fractions in enumerate(fractions_list):
    for j in range(10):
        key = f"Study2 Hypothesis {i+1} Participant {j+1}"
        if key in fractions:
            yes, no, _ = fractions[key]
            results[i, j] = yes / (yes + no) if (yes + no) != 0 else 0
        else:
            key = f"Study 2 Hypothesis {i+1} Participant {j+1}"
            if key in fractions:
                yes, no, _ = fractions[key]
                results[i, j] = yes / (yes + no) if (yes + no) != 0 else 0

fig, ax = plt.subplots(figsize=(8, 8))
x_values = np.arange(1, 5)
colormap_name = "tofino"
cmap = getattr(cmaps, colormap_name)
num_categories = 14
colors = cmap(np.linspace(0, 1, num_categories))

for participant in range(10):
    y_values = results[:, participant]
    color = colors[participant % num_categories]
    ax.scatter(x_values, y_values, label=f'Participant {participant+1}', color=color, s=100)

ax.set_ylim(0, 1)
ax.set_xticklabels([])
ax.set_yticklabels([])
ax.xaxis.set_ticks([])
plt.savefig('FractionYes_Study2.png', dpi=600)
plt.show()

# Prepare and plot for Study 1
df_filtered_study1 = df[df['Study'] == 'Study 1']

# Function to calculate fractions
def calculate_fractions(column):
    yes_fraction = np.sum(column == 'Yes') / len(column)
    no_fraction = np.sum(column == 'No') / len(column)
    nan_fraction = np.sum(column.isna()) / len(column)
    return yes_fraction, no_fraction, nan_fraction

# Calculate fractions for each hypothesis
fractions_study1 = {hypothesis: calculate_fractions(df_filtered_study1[hypothesis]) for hypothesis in ['Hypothesis 1', 'Hypothesis 2', 'Hypothesis 3', 'Hypothesis 4', 'Hypothesis 5', 'Hypothesis 6', 'Hypothesis 7']}

# Prepare data for stacked bar plot
categories_study1 = list(fractions_study1.keys())
yes_values_study1 = [fractions_study1[hypothesis][0] for hypothesis in categories_study1]
no_values_study1 = [fractions_study1[hypothesis][1] for hypothesis in categories_study1]
nan_values_study1 = [fractions_study1[hypothesis][2] for hypothesis in categories_study1]

# Plotting
# Get the right colorbar
# set colormap name
colormap_name = "tofino"
# get color map
cmap = getattr(cmaps, colormap_name)
# extract and assign colors from colormap
num_categories=30
# Sample colors from the colormap
#colors = cmap(np.linspace(0, 1, num_categories))
colors = cmap(np.linspace(0, 1, num_categories))

bar_width = 0.6
fig, ax = plt.subplots(figsize=(15,6))
ax.bar(categories_study1, yes_values_study1, bar_width, label='Yes', color=colors[20])
ax.bar(categories_study1, no_values_study1, bar_width, bottom=yes_values_study1, label='No', color=colors[4])
ax.bar(categories_study1, nan_values_study1, bar_width, bottom=np.add(yes_values_study1, no_values_study1), label='NaN', color=colors[12])

ax.set_xlabel('Participants')
ax.set_ylabel('Fraction')
ax.set_title('Fractions of "Yes" and "No" - Study 1 Hypothesis 1')
#ax.legend()
plt.xticks(rotation=90)
plt.savefig('Study1.png', dpi=600)
plt.show()


# Fraction of a significant result

investigation_values = [a + b for a, b in zip(yes_values_study1, no_values_study1)]
significance = [a/b for a, b in zip(yes_values_study1, investigation_values )]

fig, ax = plt.subplots(figsize=(8,8))
ax.scatter(np.arange(len(categories_study1))+1, significance, color='black', s=100)
ax.set_ylim(0, 1)
#ax.set_xticklabels([])
#ax.set_yticklabels([])
#plt.savefig('test.png', dpi=600)
plt.show()

