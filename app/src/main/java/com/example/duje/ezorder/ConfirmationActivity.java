package com.example.duje.ezorder;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.List;

public class ConfirmationActivity extends AppCompatActivity {

    private TextView textViewOrder;
    private Button buttonConfirm;
    private Button buttonDecline;
    private TextView textViewPrice;
    private EditText editTextRemark;
    public String allText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_confirmation);

        textViewOrder=findViewById(R.id.textViewOrder);
        buttonConfirm=findViewById(R.id.buttonConfirm);
        buttonDecline=findViewById(R.id.buttonDecline);
        textViewPrice=findViewById(R.id.textViewPrice);
        editTextRemark=findViewById(R.id.editTextRemark);

        SqlDatabaseController.GetOrder gor = new SqlDatabaseController().new GetOrder(ConfirmationActivity.this);
        gor.execute();

        buttonConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                SqlDatabaseController.ConfirmOrder cfo = new SqlDatabaseController().new ConfirmOrder(ConfirmationActivity.this, editTextRemark.getText().toString());
                cfo.execute();

                Intent intent = new Intent(ConfirmationActivity.this, LoginActivity.class);
                startActivity(intent);
            }
        });

        buttonDecline.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                SqlDatabaseController.CreateOrder cor = new SqlDatabaseController().new CreateOrder(ConfirmationActivity.this);
                cor.execute();

                Intent intent2 = new Intent(ConfirmationActivity.this, UserActivity.class);
                startActivity(intent2);
            }
        });
    }

    public void WritePrice(ViewOrder viewOrder, List<ViewOrderItem> viewOrderItems){
        textViewPrice.setText("Total price is: $" + String.valueOf(viewOrder.TotalPrice));

        for (ViewOrderItem viewOrderItem : viewOrderItems){
            if (viewOrderItem.Quantity==1){
                allText += viewOrderItem.Name + "\t\t$" + String.valueOf(viewOrderItem.Price) + "\n";
            }
            else{
                allText += viewOrderItem.Name + "\t\t$" + String.valueOf(viewOrderItem.Price) + "\t\tx" + String.valueOf(viewOrderItem.Quantity) + "\t\t$" + String.valueOf(viewOrderItem.TotalPrice) + "\n";
            }
        }
        textViewOrder.setText(allText.trim().substring(4));//to remove "null" before first food item name
    }
}
