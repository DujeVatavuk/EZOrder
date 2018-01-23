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

    private TextView TextViewOrder;
    private Button ButtonConfirm;
    private Button ButtonDecline;
    private TextView TextViewPrice;
    public String allText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_confirmation);

        TextViewOrder=findViewById(R.id.TextViewOrder);
        ButtonConfirm=findViewById(R.id.ButtonConfirm);
        ButtonDecline=findViewById(R.id.ButtonDecline);
        TextViewPrice=findViewById(R.id.TextViewPrice);

        //ode ce se izvrsit SQL klasa

        SqlDatabaseController.GetOrder getOrder = new SqlDatabaseController().new GetOrder(ConfirmationActivity.this);
        getOrder.execute();

        /*File file=new File(getFilesDir(),"todofile.txt");
        String completeText="";
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
        }*/
        /*Intent pintent = getIntent();
        int Price = pintent.getIntExtra("PRICE", 0);*/
        //TextViewPrice.setText("Total price is: $0");// + Price);//ode e doc onaj price iz baze, ne ovo moje
        //ode treba dodat da ispisuje cila narudzba (Order items)
        //TextViewOrder.setText(completeText);//treba dodat da se kroz njega moze scrollat

        ButtonConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                /*Intent intent1 = new Intent(ConfirmationActivity.this, ModeratorActivity.class);
                startActivity(intent1);*/
                //Ode necemo slat u moderator nego u login ponovo tako da se mora logirati da bi se doslo do moderatora
                Intent intent1 = new Intent(ConfirmationActivity.this, LoginActivity.class);
                startActivity(intent1);
            }
        });

        ButtonDecline.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                /*try{
                    File file = new File(getFilesDir(), "todofile.txt");
                    FileWriter writer = new FileWriter(file);
                    writer.append("");//izbrise sve sta je bilo u fileu
                    writer.flush();
                    writer.close();
                }catch (Exception e){
                    e.printStackTrace();
                }*/
                //ode treba iz baze pomogucnosti izbrisati trenutni order i napraviti novi order
                SqlDatabaseController.CreateOrder CreateOrder = new SqlDatabaseController().new CreateOrder(ConfirmationActivity.this);
                CreateOrder.execute();

                Intent intent2 = new Intent(ConfirmationActivity.this, UserActivity.class);
                startActivity(intent2);
            }
        });
    }

    public void WritePrice(ViewOrder viewOrder, List<ViewOrderItem> viewOrderItems){//cijena)
        TextViewPrice.setText("Total price is: $" + String.valueOf(viewOrder.TotalPrice));

        for (ViewOrderItem viewOrderItem : viewOrderItems){
            if (viewOrderItem.Quantity==1){
                allText += viewOrderItem.Name + "\t\t$" + String.valueOf(viewOrderItem.Price) + "\n";
            }
            else{
                allText += viewOrderItem.Name + "\t\t$" + String.valueOf(viewOrderItem.Price) + "\t\tx" + String.valueOf(viewOrderItem.Quantity) + "\t\t$" + String.valueOf(viewOrderItem.TotalPrice) + "\n";
            }
        }
        TextViewOrder.setText(allText.trim().substring(4));//iz nekog razloga prva pise null ispred imena prvog jela
    }
}
