import streamlit as st
import pandas as pd
from datetime import datetime

# App Title
st.title("📊 Daily Sales Enquiry Tracker")
st.subheader("Lead: Nilesh Agrawal, Bhanu Pratap, Ashish Agrawal, Adil Sayid")

# Initialize session state for enquiries and items if not already present
if 'enquiry_details' not in st.session_state:
    st.session_state['enquiry_details'] = {}
if 'enquiry_items' not in st.session_state:
    st.session_state['enquiry_items'] = []

# Full Item Description List (used in filtering)
item_descriptions = [
    "ISA 50X50X6", "ISA 65X65X6", "ISA 65X65X8", "ISA 65X65X10", "ISA 75X75X6", 
    "ISA 75X75X8", "ISA 75X75X10", "ISA 90X90X6", "ISA 90X90X8", "ISA 90X90X10", 
    "ISA 90X90X12", "ISA 100X100X6", "ISA 100X100X8", "ISA 100X100X10", "ISA 100X100X12", 
    "ISA 110X110X8", "ISA 110X110X10", "ISA 110X110X12", "ISA 110X110X16", "ISA 130X130X8", 
    "ISA 130X130X10", "ISA 130X130X12", "ISA 130X130X16", "ISA 150X150X10", "ISA 150X150X12", 
    "ISA 150X150X16", "ISA 150X150X20", "ISA 200X200X12", "ISA 200X200X16", "ISA 200X200X20", 
    "ISA 200X200X25", "ISMB 150X75", "ISMB 150X80", "ISMB 200X100", "ISMB 250X125", "ISMB 300X140", 
    "ISMB 350X140", "ISMB 400X140", "ISMB 450X150", "ISMB 500X180", "ISMB 600X210", "ISMC 75X40", 
    "ISMC 100X50", "ISMC 125X65", "ISMC 150X75", "ISMC 175X75", "ISMC 200X75", "ISMC 250X80", 
    "ISMC 250X82", "ISMC 300X90", "ISMC 300X92", "ISMC 400X100", "NPB 200X100X22", "NPB 200X100X25", 
    "NPB 250X125X30", "NPB 300X150X36", "NPB 300X150X42", "NPB 300X150X49", "NPB 350X170X50", 
    "NPB 350X170X57", "NPB 400X180X57", "NPB 400X180X66", "NPB 450X190X67", "NPB 450X190X92", 
    "NPB 450X190X77", "NPB 500X200X79", "NPB 500X200X90", "NPB 500X200X107", "WPB 160X160X30", 
    "WPB 200X200X37", "WPB 200X200X42", "WPB 200X200X61", "WPB 240X240X47", "WPB 240X240X60", 
    "WPB 240X240X83", "WPB 300X300X101", "WPB 300X300X117", "WPB 600X300X128.8", "WPB 600X300X177.8", 
    "WPB 600X300X211.9", "MS PLATE 5MM", "MS PLATE 6MM", "MS PLATE 8MM", "MS PLATE 10MM", 
    "MS PLATE 12MM", "MS PLATE 14MM", "MS PLATE 16MM", "MS PLATE 20MM", "MS PLATE 25MM", 
    "MS PLATE 30MM", "MS PLATE 32MM", "MS PLATE 40MM", "CHQ PLATE 5MM", "CHQ PLATE 6MM", 
    "CHQ PLATE 8MM", "COMM.RAIL 52KG", "COMM.RAIL 60KG", "RAIL CR 80", "RAIL CR 100", "RAIL CR 120", 
    "RAIL IRS 52", "UB 152X89X16", "UB 203X133X25", "UB 203X133X30", "UB 254X146X31", "UB 254X146X37", 
    "UB 254X146X43", "UB 305X165X40", "UB 305X165X46", "UB 305X165X54", "UB 356X171X45", 
    "UB 356X171X51", "UB 356X171X57", "UB 356X171X67", "UB 406X178X54", "UB 406X178X60", 
    "UB 406X178X67", "UB 406X178X74", "UB 457X152X52", "UB 457X152X60", "UB 457X152X67", 
    "UB 457X152X74", "UB 457X152X82", "UB 457X191X67", "UB 457X191X74", "UB 457X191X82", 
    "UB 457X191X89", "UB 457X191X98", "UB 533X210X82", "UB 533X210X92", "UB 533X210X101", 
    "UB 533X210X109", "UB 533X210X122", "UB 610X229X101", "UB 610X229X113", "UB 610X229X125", 
    "UB 610X229X140", "UC 152X152X23", "UC 152X152X30", "UC 152X152X37", "UC 203X203X37", 
    "UC 203X203X46", "UC 203X203X52", "UC 203X203X60", "UC 203X203X71", "UC 203X203X86", 
    "UC 254X254X73", "UC 254X254X89", "UC 254X254X107", "UC 254X254X132", "UC 254X254X167", 
    "UC 305X305X97", "UC 305X305X118", "UC 305X305X137", "UC 305X305X158", "UC 305X305X163", 
    "UC 305X305X198", "UC 305X305X240", "UC 305X305X283", "UC 356X368X129", "UC 356X368X153", 
    "UC 356X368X177", "UC 356X368X202", "UC 356X406X235", "UC 356X406X287", "MS PLATE 3.15MM", 
    "TMT 10MM", "TMT 12MM", "TMT 16MM", "TMT 20MM", "TMT 26MM", "TMT 32MM"
]

# Main Enquiry Form
with st.form("enquiry_form"):
    st.markdown("### 📝 Enquiry Details")
    enquiry_date = st.date_input("Enquiry Date", datetime.today())
    enquiry_time = st.time_input("Enquiry Time", datetime.now().time())
    lead_by = st.selectbox("Lead By", ["Nilesh Agrawal", "Bhanu Pratap", "Ashish Agrawal", "Adil Sayid"])
    enquiry_by = st.text_input("Enquiry Received By")
    party_name = st.text_input("Party Name")
    party_type = st.radio("Party Type", ["Trader", "Supplier", "Buyer"])
    submit_enquiry = st.form_submit_button("Save Enquiry")

    if submit_enquiry:
        st.session_state['enquiry_details'] = {
            "Date": enquiry_date,
            "Time": enquiry_time,
            "Lead By": lead_by,
            "Enquiry By": enquiry_by,
            "Party Name": party_name,
            "Party Type": party_type
        }
        st.success("✅ Enquiry Details Saved")

# Item Entry Section with Filter/Search
st.markdown("### 📦 Add Item to Enquiry")
search_term = st.text_input("Search Item (e.g., ISA, ISMB)", "")  # Search bar
filtered_items = [item for item in item_descriptions if search_term.lower() in item.lower()]

with st.form("item_form"):
    material_name = st.selectbox("Material Name", sorted(filtered_items))
    grade = st.selectbox("Grade", ["E250A", "E250B", "E350A", "Other"])
    make = st.selectbox("Make", ["SAIL", "RINL", "JSPL", "Imported", "Other"])
    enquiry_qty = st.number_input("Enquiry Quantity (MT)", min_value=0.0, format="%.2f")
    offer_qty = st.number_input("Offered Quantity (MT)", min_value=0.0, format="%.2f")
    balance_qty = st.number_input("Balance Quantity (MT)", min_value=0.0, format="%.2f")
    rate = st.number_input("Rate (₹/MT)", min_value=0.0, format="%.2f")
    submit_item = st.form_submit_button("Add Item")

    if submit_item:
        if offer_qty > enquiry_qty:
            st.error("Offered Quantity cannot exceed Enquiry Quantity.")
        else:
            st.session_state['enquiry_items'].append({
                "Material Name": material_name,
                "Grade": grade,
                "Make": make,
                "Enquiry Qty (MT)": enquiry_qty,
                "Offered Qty (MT)": offer_qty,
                "Balance Qty (MT)": balance_qty,
                "Rate (₹/MT)": rate
            })
            st.success(f"✅ Item {material_name} added to Enquiry")

# Display saved items
if st.session_state['enquiry_items']:
    st.markdown("### 📑 Items Added")
    items_df = pd.DataFrame(st.session_state['enquiry_items'])
    st.dataframe(items_df)

    # Export button
    csv = items_df.to_csv(index=False).encode('utf-8')
    st.download_button("📥 Download Items CSV", csv, "enquiry_items.csv", "text/csv")
