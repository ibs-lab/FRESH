import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeature
from cartopy.io.img_tiles import GoogleTiles

# List of cities with their latitude and longitude
cities = {
    'Aachen': (50.7779, 6.0775),
    'Beersheba': (31.2614, 34.7996),
    'Boston': (42.3375, -71.1054),
    'Campinas': (-22.8184, -47.0647),
    'Chemnitz': (50.8398, 12.9278),
    'East Melbourne': (-37.8095, 144.9780),
    'Göttingen': (51.5505, 9.9428),
    'Guildford': (51.2431, -0.5895),
    'Houston': (29.7199, -95.3422),
    'Ikeda': (34.8211, 135.4364),
    'Istanbul': (40.9784, 29.1103),
    'Lille': (50.6320, 3.0753),
    'London': (51.5219, -0.1303),
    'Lublin': (51.2475, 22.5450),
    'Lyngby': (55.7856, 12.5214),
    'Maastricht': (50.8470, 5.6880),
    'Mabdeburg': (52.1401, 11.6447),
    'Merced': (37.3022, -120.4830),
    'Minxiong': (23.5586, 120.4719),
    'Montpellier': (43.6158, 3.8721),
    'Montreal': (45.5031, -73.6244),
    'Oldenburg': (53.1467, 8.1831),
    'Omaha': (41.2580, -96.0107),
    'Ottignies-Louvain-la-Neuve': (50.6697, 4.6159),
    'Padua': (45.4067, 11.8772),
    'Rennes': (48.1157, -1.6731),
    'San Luis Potosí': (22.1525, -100.9781),
    'Snekkersten': (56.0147, 12.5529),
    'Solna': (59.3481, 18.0237),
    'St. Louis': (38.6488, -90.3108),
    'Stanford': (37.4277, -122.1701),
    'Tehran': (35.7022, 51.3957),
    'Tel Aviv': (32.1133, 34.8044),
    'Tuebingen': (48.5362, 9.0367),
    'Washington': (38.9380, -77.0889),
    'West Lafayette': (40.4237, -86.9212),
   }

# Create a map with a basic PlateCarree projection (which is a basic cylindrical projection)
fig = plt.figure(figsize=(10, 5))
ax = fig.add_subplot(1, 1, 1, projection=ccrs.PlateCarree())

# Draw the base map with satellite imagery
ax.add_image(GoogleTiles(style='satellite'), 4)  # The '4' here is the zoom level

# Plot city points on the map
for city, (lat, lon) in cities.items():
    ax.plot(lon, lat, marker='o', markersize=5, color='red', transform=ccrs.Geodetic(), label=city)

# Add a legend to the map
# plt.legend(loc='lower left')

# Set the extent to show the whole world
ax.set_global()

# Save figure
plt.savefig('presentation.png',format='png',dpi=600)

# Show the map
plt.show()