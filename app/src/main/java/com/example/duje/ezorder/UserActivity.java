package com.example.duje.ezorder;

import android.content.Intent;
import android.database.DataSetObserver;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
//import android.widget.ExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.ListAdapter;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class UserActivity extends AppCompatActivity {

    private ExpandableListView  listView;
    private Button buttonOrder;
    private FoodExpandableListAdapter listAdapter;

    public float price=0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user);

        listView=findViewById(R.id.lvExp);
        buttonOrder=findViewById(R.id.buttonOrder);

        SqlDatabaseController.GetFoodCategory gfc = new SqlDatabaseController().new GetFoodCategory(UserActivity.this);
        gfc.execute();

        buttonOrder.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                if (price == 0) {
                    Toast.makeText(getApplicationContext(), "You have to choose somethng before ordering", Toast.LENGTH_SHORT).show();
                }
                else {
                    Intent intent = new Intent(UserActivity.this, ConfirmationActivity.class);
                    startActivity(intent);
                }
            }
        });

        listView.setOnChildClickListener(new ExpandableListView.OnChildClickListener() {
            @Override
            public boolean onChildClick(ExpandableListView expandableListView, View view, int i, int i1, long l) {
                final FoodItem selected = (FoodItem) listAdapter.getChild(i, i1);

                SqlDatabaseController.CreateOrderItem createOrderItem = new SqlDatabaseController().new CreateOrderItem(UserActivity.this, selected.Id);
                createOrderItem.execute();

                Toast.makeText(getApplicationContext(), selected.Name, Toast.LENGTH_SHORT).show();
                price += selected.Price;//used so we can see if anything is picked

                return true;
            }
        });
    }

    public void InitData(List<FoodCategory> FoodCategories, List<FoodItem> FoodItems) {

        listAdapter = new FoodExpandableListAdapter(this, FoodCategories, FoodItems);
        listView.setAdapter(listAdapter);
        //Toast.makeText(getApplicationContext(), "Order: " + String.valueOf(Order.getInstance().Id), Toast.LENGTH_SHORT).show();
    }
}
