import streamlit as st
import pandas as pd
from datetime import datetime
import os

# CSV file path
csv_file = "sales_data.csv"

# Load existing data or create new
if os.path.exists(csv_file):
    data = pd.read_csv(csv_file)
else:
    data = pd.DataFrame(columns=["Date", "Customer Name", "Product", "Quantity", "Remarks"])

st.set_page_config(page_title="Daily Sales Enquiry", page_icon="📊", layout="wide")
st.title("📊 Daily Sales Enquiry App")

# Form to add a new enquiry
with st.expander("➕ Add New Enquiry"):
    with st.form("enquiry_form"):
        col1, col2, col3 = st.columns(3)
        with col1:
            date = st.date_input("Date", value=datetime.today())
        with col2:
            customer = st.text_input("Customer Name")
        with col3:
            product = st.text_input("Product")

        quantity = st.number_input("Quantity", min_value=0)
        remarks = st.text_area("Remarks")

        submitted = st.form_submit_button("Add Enquiry")

        if submitted:
            new_data = pd.DataFrame([[date, customer, product, quantity, remarks]], 
                                    columns=data.columns)
            data = pd.concat([data, new_data], ignore_index=True)
            data.to_csv(csv_file, index=False)
            st.success("✅ Enquiry added successfully!")

# Display dashboard stats
st.subheader("📊 Enquiry Dashboard")
col1, col2, col3 = st.columns(3)
col1.metric("Total Enquiries", len(data))
col2.metric("Total Quantity", int(data["Quantity"].sum()))
col3.metric("Unique Products", data["Product"].nunique())

# Search and filter options
st.subheader("📋 Enquiry Records")

with st.expander("🔍 Filter Records"):
    search_date = st.date_input("Filter by Date", value=None)
    search_customer = st.text_input("Filter by Customer")
    search_product = st.text_input("Filter by Product")

    filtered_data = data.copy()
    if search_date:
        filtered_data = filtered_data[filtered_data["Date"] == str(search_date)]
    if search_customer:
        filtered_data = filtered_data[filtered_data["Customer Name"].str.contains(search_customer, case=False)]
    if search_product:
        filtered_data = filtered_data[filtered_data["Product"].str.contains(search_product, case=False)]

# Display data table
st.dataframe(filtered_data)

# Download button
st.download_button("⬇️ Download CSV", data.to_csv(index=False), "sales_data.csv")

