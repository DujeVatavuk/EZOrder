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
    Button buttonFinish;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_moderator);

        linearMain = findViewById(R.id.linearMain);
        textViewInfo=findViewById(R.id.textViewInfo);
        buttonFinish=findViewById(R.id.buttonFinish);

        LinkedHashMap<String, String> OrderItemList = new LinkedHashMap<>();//<String, String>

        SqlDatabaseController.ModerateOrder mor = new SqlDatabaseController().new ModerateOrder(ModeratorActivity.this, OrderItemList);
        mor.execute();

        buttonFinish.setOnClickListener(new View.OnClickListener() {
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

    void FillLinkedHashMap(List<ViewOrderItem> viewOrderItems, LinkedHashMap<String, String> OrderItemList){
        int k=1;
        for (ViewOrderItem viewOrderItem : viewOrderItems){
            OrderItemList.put(String.valueOf(k), viewOrderItem.Name);
            k++;
        }
        Set<?> set = OrderItemList.entrySet();
        Iterator<?> i = set.iterator();

        while (i.hasNext()) {
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

    void ShowOrderInfo(List<ViewOrder> viewOrders){
        for (ViewOrder viewOrder : viewOrders){
            textViewInfo.setText("Order ID: " + String.valueOf(viewOrder.Id) + "\nTable ID: " + String.valueOf(viewOrder.TableId) + "\nTotal price: $" + String.valueOf(viewOrder.TotalPrice) + "\nDate: " + String.valueOf(viewOrder.Ordered) + "\nRemark: \"" + String.valueOf(viewOrder.Remark) + "\"");
        }
    }
}
