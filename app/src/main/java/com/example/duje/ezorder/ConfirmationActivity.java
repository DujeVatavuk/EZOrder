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

public class ConfirmationActivity extends AppCompatActivity {

    private TextView TextViewOrder;
    private Button ButtonConfirm;
    private Button ButtonDecline;
    private TextView TextViewPrice;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_confirmation);

        TextViewOrder=findViewById(R.id.TextViewOrder);
        ButtonConfirm=findViewById(R.id.ButtonConfirm);
        ButtonDecline=findViewById(R.id.ButtonDecline);
        TextViewPrice=findViewById(R.id.TextViewPrice);

        File file=new File(getFilesDir(),"todofile.txt");
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
        }
        Intent pintent=getIntent();
        int Price = pintent.getIntExtra("PRICE", 0);
        TextViewPrice.setText("Total price is: $"+Price);

        ButtonConfirm.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent1 = new Intent(ConfirmationActivity.this, ModeratorActivity.class);
                startActivity(intent1);
            }
        });

        ButtonDecline.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent2 = new Intent(ConfirmationActivity.this, UserActivity.class);
                try{
                    File file = new File(getFilesDir(), "todofile.txt");
                    FileWriter writer = new FileWriter(file);
                    writer.append("");//izbrise sve sta je bilo u fileu
                    writer.flush();
                    writer.close();
                }catch (Exception e){
                    e.printStackTrace();
                }
                startActivity(intent2);
            }
        });

        TextViewOrder.setText(completeText);

    }
}
