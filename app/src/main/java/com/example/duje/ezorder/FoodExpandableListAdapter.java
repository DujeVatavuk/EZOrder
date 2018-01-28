package com.example.duje.ezorder;

import android.content.Context;
import android.graphics.Typeface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.TextView;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;


public class FoodExpandableListAdapter extends BaseExpandableListAdapter {
    private Context context;
    private List<FoodCategory> listDataHeader;
    private HashMap<FoodCategory,List<FoodItem>> listHashMap;

    public FoodExpandableListAdapter(Context context, List<FoodCategory> FoodCategories, List<FoodItem> FoodItems) {
        this.context = context;
        this.listDataHeader = FoodCategories;
        this.listHashMap = new HashMap<>();//<FoodCategory,List<FoodItem>>

        for (FoodCategory foodCategory : FoodCategories) {
            ArrayList<FoodItem> foodItemsArray = new ArrayList<>();//<FoodItem>

            for (FoodItem foodItem: FoodItems) {
                if (foodItem.FoodCategoryId == foodCategory.Id) {
                    foodItemsArray.add(foodItem);
                }
            }

            this.listHashMap.put(foodCategory,foodItemsArray);
        }
    }

    @Override
    public int getGroupCount() {
        return listDataHeader.size();
    }

    @Override
    public int getChildrenCount(int i) {
        return listHashMap.get(listDataHeader.get(i)).size();
    }

    @Override
    public Object getGroup(int i) {
        return listDataHeader.get(i);
    }

    @Override
    public Object getChild(int i, int i1) {
        return listHashMap.get(listDataHeader.get(i)).get(i1); // i = Group Item , i1 = ChildItem
    }

    @Override
    public long getGroupId(int i) {
        return listDataHeader.get(i).Id;
    }

    @Override
    public long getChildId(int i, int i1) {
        return  listHashMap.get(listDataHeader.get(i)).get(i1).Id;
    }

    @Override
    public boolean hasStableIds() {
        return true;
    }

    @Override
    public View getGroupView(int i, boolean b, View view, ViewGroup viewGroup) {
        String headerTitle = ((FoodCategory)getGroup(i)).Name;
        if(view == null)
        {
            LayoutInflater inflater = (LayoutInflater)this.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = inflater.inflate(R.layout.list_group,null);
        }
        TextView lblListHeader = view.findViewById(R.id.lblListHeader);
        lblListHeader.setTypeface(null, Typeface.BOLD);
        lblListHeader.setText(headerTitle);
        return view;
    }

    @Override
    public View getChildView(int i, int i1, boolean b, View view, ViewGroup viewGroup) {
        FoodItem foodItem = (FoodItem)getChild(i,i1);

        String priceFormated = NumberFormat.getCurrencyInstance(new Locale("en", "US"))
                .format(foodItem.Price);

        final String childText = priceFormated + "     " + foodItem.Name;

        if(view == null)
        {
            LayoutInflater inflater = (LayoutInflater)this.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = inflater.inflate(R.layout.list_item,null);
        }

        TextView txtListChild = (TextView)view.findViewById(R.id.lblListItem);
        txtListChild.setText(childText);
        return view;
    }

    @Override
    public boolean isChildSelectable(int i, int i1) {
        return true;
    }
}
