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
    private Button ButtonOrder;
    private FoodExpandableListAdapter listAdapter;

    public float price=0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_user);

        listView=findViewById(R.id.lvExp);
        ButtonOrder=findViewById(R.id.ButtonOrder);

        //InitData();
        SqlDatabaseController.GetFoodCategory gfc = new SqlDatabaseController().new GetFoodCategory(UserActivity.this);
        gfc.execute();

        ButtonOrder.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                /*File file = new File(getFilesDir(), "todofile.txt");*/

                if (price == 0) {
                    Toast.makeText(getApplicationContext(), "You have to choose somethng before ordering", Toast.LENGTH_SHORT).show();
                }
                else {
                    //Toast.makeText(getApplicationContext(), String.valueOf(price), Toast.LENGTH_SHORT).show();
                    Intent intent = new Intent(UserActivity.this, ConfirmationActivity.class);
                    //intent.putExtra("PRICE", price);//u ConfirmActivityu ce bit price iz baze
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

                Toast.makeText(getApplicationContext(), selected.Name /*pise string onog kojeg sam kliknija*/, Toast.LENGTH_SHORT).show();
                //ideja je da upsiem u file sve childove koje sam pritisa i onda ih procitam u iducem activityu
/*                try {
                    File file = new File(getFilesDir(), "todofile.txt");
                    FileWriter writer = new FileWriter(file, true);
                    writer.append(selected.Name+"\n");//treba namistit da samo svaki put kad pritisnem doda, a ne da prepise staro
                    writer.flush();
                    writer.close();
                } catch (Exception e){
                    e.printStackTrace();
                }*/
                price += selected.Price;

                return true;
            }
        });
    }

    public void InitData(
            List<FoodCategory> FoodCategories,
            List<FoodItem> FoodItems
    ) {
        // convert to List<String>

        listAdapter = new FoodExpandableListAdapter(this, FoodCategories, FoodItems);
        listView.setAdapter(listAdapter);

        Toast.makeText(getApplicationContext(), "Order: " + String.valueOf(Order.getInstance().Id), Toast.LENGTH_SHORT).show();
    }
}
