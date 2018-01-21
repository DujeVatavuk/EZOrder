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
    private ExpandableListAdapter listAdapter;

    public int price=0;

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
                File file = new File(getFilesDir(), "todofile.txt");

                if (file.length()==0) {
                    Toast.makeText(getApplicationContext(), "Morate bar nesto odabrati prije provjere narudzbe", Toast.LENGTH_SHORT).show();
                }
                else {
                    Intent intent = new Intent(UserActivity.this, ConfirmationActivity.class);
                    intent.putExtra("PRICE", price);
                    startActivity(intent);
                }
            }
        });

        listView.setOnChildClickListener(new ExpandableListView.OnChildClickListener() {
            @Override
            public boolean onChildClick(ExpandableListView expandableListView, View view, int i, int i1, long l) {
                final String selected = (String) listAdapter.getChild(
                        i, i1);
                Toast.makeText(getApplicationContext(), selected /*pise string onog kojeg sam kliknija*/, Toast.LENGTH_SHORT).show();
                //ideja je da upsiem u file sve childove koje sam pritisa i onda ih procitam u iducem activityu
                try {
                    File file = new File(getFilesDir(), "todofile.txt");
                    FileWriter writer = new FileWriter(file, true);
                    writer.append(selected+"\n");//treba namistit da samo svaki put kad pritisnem doda, a ne da prepise staro
                    writer.flush();
                    writer.close();
                } catch (Exception e){
                    e.printStackTrace();
                }

                switch (selected)
                {
                    case "$2        Mineral water":
                        price+=2;
                        break;
                    case "$3        Braised Onion Sauce":
                    case "$3        Coca-Cola":
                    case "$3        Sprite":
                    case "$3        Fanta":
                    case "$3        Black tea":
                    case "$3        Mint tea":
                    case "$3        Green tea":
                    case "$3        Ice Tea":
                        price+=3;
                        break;
                    case "$4        Creamy Mushroom Soup":
                    case "$4        Eggplant Parmesan":
                    case "$4        Beans and Greens Soup":
                    case "$4        Espresso":
                    case "$4        Americano":
                    case "$4        Latte":
                        price+=4;
                        break;
                    case "$5        The Ghostie Sandwich":
                    case "$5        Chicken Kiev":
                    case "$5        Chicken Tamale Pie":
                    case "$5        Summertime Peach Ice Cream":
                        price+=5;
                        break;
                    case "$7        Short Rib Ragu":
                    case "$7        Rib Chili":
                    case "$7        All-Time Favorite Chocolate Chip Cookies":
                    case "$7        Mom's Pecan Pie":
                    case "$7        Heavenly Key Lime Pie":
                    case "$7        Classic Strawberry Shortcake":
                    case "$7        7-UP":
                        price+=7;
                        break;
                    case "$8        \"Greek\" Lamb with Orzo":
                    case "$8        Classic Chess Pie":
                    case "$8        Best Carrot Cake":
                        price+=8;
                        break;
                    case "$10      Beef Bourguignon":
                    case "$10      Linguine with Sardines, Fennel & Tomato":
                    case "$10      Pizza Margherita":
                    case "$10      Pecan-Peach Cobbler":
                    case "$10      Mississippi Mud Brownies (doesn't contain mud)":
                        price+=10;
                        break;
                    case "$12      Balado Pizza":
                    case "$12      Satay Pizza":
                        price+=12;
                        break;
                    case "$13      Liguria Pizza":
                    case "$13      Pomodoro Pachina and Rughetta":
                        price+=13;
                        break;
                    case "$15      Tikka Chicken Pizza":
                    case "$15      Pizza Alla Napoletana (Napoli)":
                    case "$15      Pizza Marinara":
                    case "$15      Pizza Romana":
                    case "$15      Chocolate-Red Velvet Layer Cake":
                    case "$15      Chocolate-Peanut Butter Mousse Cake":
                        price+=15;
                        break;
                    case "$17      Pizza Ai Quattro Formagi":
                        price+=17;
                        break;
                    case "$20      Pizza quattro stagioni":
                        price+=20;
                        break;
                    case "$25      Hawaiian Pizza (pineapple)":
                        price+=25;
                        break;
                    case "$999 999 Million Dollar Pound Cake (doesn't cost million dollars)":
                        price+=999999;
                        break;
                }
                return true;
            }
        });
    }

    public void InitData(
            List<FoodCategory> FoodCategories,
            List<FoodItem> FoodItems
    ) {
        // convert to List<String>
        List<String> listDataHeader = new ArrayList<String>();
        HashMap<String,List<String>> listHash = new HashMap<String,List<String>>();

        for (FoodCategory foodCategory : FoodCategories) {
            listDataHeader.add(foodCategory.Name);
        }

        for (FoodCategory foodCategory : FoodCategories) {
            ArrayList<String> foodItemsArray = new ArrayList<String>();

            for (FoodItem foodItem: FoodItems) {
                if (foodItem.FoodCategoryId == foodCategory.Id) {
                    String priceFormated = NumberFormat.getCurrencyInstance(new Locale("en", "US"))
                            .format(foodItem.Price);

                    foodItemsArray.add(priceFormated + "     " + foodItem.Name);
                }
            }

            listHash.put(foodCategory.Name,foodItemsArray);
        }

        listAdapter = new ExpandableListAdapter(this,listDataHeader,listHash);
        listView.setAdapter(listAdapter);
    }
}
