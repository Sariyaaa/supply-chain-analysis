import pandas as pd
import matplotlib.pyplot as plt

# Load dataset
df = pd.read_csv(r"C:\Users\91726\OneDrive\Desktop\supply_chain_cleaned.csv", encoding='latin1')

# Analysis 1 - Total Rows
print("Total Rows:", len(df))

# Analysis 2 - Delivery Status
print("\nDelivery Status:")
print(df["Delivery Status"].value_counts())

# Analysis 3 - Top Regions
print("\nTop Regions:")
print(df["Order Region"].value_counts().head(5))

# Analysis 4 - Shipping Mode
print("\nShipping Mode:")
print(df["Shipping Mode"].value_counts())

# Chart
df["Delivery Status"].value_counts().plot(kind="bar", color="steelblue")
plt.title("Delivery Status Distribution")
plt.tight_layout()
plt.savefig(r"C:\Users\91726\OneDrive\Desktop\delivery_status.png")
plt.show()
print("Done!")