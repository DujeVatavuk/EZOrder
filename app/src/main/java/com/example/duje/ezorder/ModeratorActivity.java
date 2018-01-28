package com.example.duje.ezorder;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.EOFException;
import java.io.File;
import java.io.FileReader;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class ModeratorActivity extends AppCompatActivity {

    LinearLayout linearMain;
    CheckBox checkBox;
    TextView textViewInfo;
    Button ButtonFinish;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_moderator);

        //ode dinamicki trebam stavit checkboxove za svaki item sa narudzbe

        linearMain = findViewById(R.id.linearMain);
        textViewInfo=findViewById(R.id.textViewInfo);
        ButtonFinish=findViewById(R.id.ButtonFinish);
        LinkedHashMap<String, String> OrderItemList = new LinkedHashMap<String, String>();
        SqlDatabaseController.ModerateOrder moderateOrder = new SqlDatabaseController().new ModerateOrder(ModeratorActivity.this, OrderItemList);
        moderateOrder.execute();
        /**
         * create linked hash map for store item you can get value from database
         * or server also
         */
        /*File file=new File(getFilesDir(),"todofile.txt");
        String completeText="";//sad ovo je jedan string u vise redova, sad njega treba prebacit u linked hash map
        try{
            FileReader reader=new FileReader(file);
            BufferedReader br = new BufferedReader(reader);
            String sCurrentLine;
            while ((sCurrentLine = br.readLine()) != null) {
                completeText+=sCurrentLine+"\n";
                System.out.println(sCurrentLine);
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        LinkedHashMap<String, String> alphabet = new LinkedHashMap<String, String>();
        int j=0;
        String[] splitData = completeText.trim().split("\n");

        for (String eachSplit : splitData) {
            j++;
            alphabet.put(Integer.toString(j), eachSplit);
        }*/
        /*LinkedHashMap<String, String> alphabet = new LinkedHashMap<String, String>();//mozda ne mora bas bit hash map
        alphabet.put("1", "Apple");
        alphabet.put("2", "Boy");
        alphabet.put("3", "Cat");
        alphabet.put("4", "Dog");
        alphabet.put("5", "Eet");
        alphabet.put("6", "Fat");
        alphabet.put("7", "Goat");
        alphabet.put("8", "Hen");
        alphabet.put("9", "I am");
        alphabet.put("10", "Jug");*/
        /*OrderItemList.put("8", "Hen");
        OrderItemList.put("9", "I am");
        OrderItemList.put("10", "Jug");*/
        /*Set<?> set = OrderItemList.entrySet();
        // Get an iterator
        Iterator<?> i = set.iterator();
        // Display elements
        while (i.hasNext()) {
            @SuppressWarnings("rawtypes")
            Map.Entry me = (Map.Entry) i.next();
            System.out.print(me.getKey() + ": ");
            System.out.println(me.getValue());

            checkBox = new CheckBox(this);
            checkBox.setId(Integer.parseInt(me.getKey().toString()));
            checkBox.setText(me.getValue().toString());
            checkBox.setOnClickListener(getOnClickDoSomething(checkBox));
            linearMain.addView(checkBox);
        }*/
        ButtonFinish.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SqlDatabaseController.ExecuteOrder executeOrder = new SqlDatabaseController().new ExecuteOrder(ModeratorActivity.this);
                executeOrder.execute();

                Intent intent = new Intent(ModeratorActivity.this, LoginActivity.class);
                startActivity(intent);
            }
        });

    }

    View.OnClickListener getOnClickDoSomething(final Button button) {
        return new View.OnClickListener() {
            public void onClick(View v) {
                System.out.println("*************id******" + button.getId());
                System.out.println("and text***" + button.getText().toString());
            }
        };
    }

    void fillLinkedHashMap(List<ViewOrderItem> viewOrderItems, LinkedHashMap<String, String> OrderItemList){
        int k=1;
        for (ViewOrderItem viewOrderItem : viewOrderItems){
            OrderItemList.put(String.valueOf(k), viewOrderItem.Name);
            k++;
        }
        Set<?> set = OrderItemList.entrySet();
        // Get an iterator
        Iterator<?> i = set.iterator();

        // Display elements
        while (i.hasNext()) {
            @SuppressWarnings("rawtypes")
            Map.Entry me = (Map.Entry) i.next();
            System.out.print(me.getKey() + ": ");
            System.out.println(me.getValue());

            checkBox = new CheckBox(this);
            checkBox.setId(Integer.parseInt(me.getKey().toString()));
            checkBox.setText(me.getValue().toString());
            checkBox.setOnClickListener(getOnClickDoSomething(checkBox));
            linearMain.addView(checkBox);
        }
    }

    void MetodaZaTestiranje(List<ViewOrder> viewOrders){
        for (ViewOrder viewOrder : viewOrders){
            textViewInfo.setText("Order ID: " + String.valueOf(viewOrder.Id) + "\nTable ID: " + String.valueOf(viewOrder.TableId) + "\nTotal price: $" + String.valueOf(viewOrder.TotalPrice) + "\nDate: " + String.valueOf(viewOrder.Ordered) + "\nRemark: \"" + String.valueOf(viewOrder.Remark) + "\"");
        }
    }
}
