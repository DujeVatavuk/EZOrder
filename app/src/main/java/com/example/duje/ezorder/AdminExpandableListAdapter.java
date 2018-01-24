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

/**
 * Created by duje on 24.1.2018..
 */

public class AdminExpandableListAdapter extends BaseExpandableListAdapter {
    private Context context;
    private List<ViewOrder> listDataHeader;
    private HashMap<ViewOrder,List<ViewOrderItem>> listHashMap;

    public AdminExpandableListAdapter(Context context, List<ViewOrder> viewOrders, List<ViewOrderItem> viewOrderItems) {
        this.context = context;
        this.listDataHeader = viewOrders;
        this.listHashMap = new HashMap<ViewOrder,List<ViewOrderItem>>();

        /*
        for (FoodCategory foodCategory : FoodCategories) {
            listDataHeader.add(foodCategory.Name);
        }*/

        /*for (FoodCategory foodCategory : FoodCategories) {
            ArrayList<FoodItem> foodItemsArray = new ArrayList<FoodItem>();

            for (FoodItem foodItem: FoodItems) {
                if (foodItem.FoodCategoryId == foodCategory.Id) {
                    foodItemsArray.add(foodItem);
                }
            }

            this.listHashMap.put(foodCategory,foodItemsArray);
        }*/
        for (ViewOrder viewOrder : viewOrders) {
            ArrayList<ViewOrderItem> viewOrderItemArray = new ArrayList<ViewOrderItem>();

            for (ViewOrderItem viewOrderItem: viewOrderItems) {
                if (viewOrderItem.OrderId == viewOrder.Id) {
                    viewOrderItemArray.add(viewOrderItem);
                }
            }

            this.listHashMap.put(viewOrder,viewOrderItemArray);
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
        //return i;
        return listDataHeader.get(i).Id;
    }

    @Override
    public long getChildId(int i, int i1) {
        //return i1;
        return  listHashMap.get(listDataHeader.get(i)).get(i1).OrderId;
    }

    @Override
    public boolean hasStableIds() {
        return true;
    }

    @Override
    public View getGroupView(int i, boolean b, View view, ViewGroup viewGroup) {
        String headerTitle = String.valueOf(((ViewOrder)getGroup(i)).Id) + "  " + String.valueOf(((ViewOrder)getGroup(i)).TableId) + "  $" + String.valueOf(((ViewOrder)getGroup(i)).TotalPrice) + "  " + String.valueOf(((ViewOrder)getGroup(i)).Ordered);
        if(view == null)
        {
            LayoutInflater inflater = (LayoutInflater)this.context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = inflater.inflate(R.layout.list_group,null);
        }
        TextView lblListHeader = (TextView)view.findViewById(R.id.lblListHeader);
        lblListHeader.setTypeface(null, Typeface.BOLD);
        lblListHeader.setText(headerTitle);
        return view;
    }

    @Override
    public View getChildView(int i, int i1, boolean b, View view, ViewGroup viewGroup) {
        ViewOrderItem viewOrderItem = (ViewOrderItem) getChild(i,i1);

        String priceFormated = NumberFormat.getCurrencyInstance(new Locale("en", "US"))
                .format(viewOrderItem.Price);

        String totalPriceFormated = NumberFormat.getCurrencyInstance(new Locale("en", "US"))
                .format(viewOrderItem.TotalPrice);

        final String childText = viewOrderItem.Name + "  " + priceFormated + "  x" + viewOrderItem.Quantity + "  " + totalPriceFormated;

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
