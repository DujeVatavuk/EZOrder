package com.example.duje.ezorder;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.StrictMode;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

public class LoginActivity extends AppCompatActivity {

    private AutoCompleteTextView autoCompleteTextViewUsername;
    private EditText editTextPassword;
    private Button buttonNoLogIn;
    private Button buttonLogIn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        autoCompleteTextViewUsername=findViewById(R.id.autoCompleteTextViewUsername);
        editTextPassword=findViewById(R.id.editTextPassword);
        buttonNoLogIn=findViewById(R.id.buttonNoLogIn);
        buttonLogIn=findViewById(R.id.buttonLogIn);

        buttonNoLogIn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                SqlDatabaseController.CreateOrder cor = new SqlDatabaseController().new CreateOrder(LoginActivity.this);
                cor.execute();

                Intent intent = new Intent(LoginActivity.this, UserActivity.class);
                startActivity(intent);

            }
        });

        buttonLogIn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                if (autoCompleteTextViewUsername.getText().toString().equals("Admin") && editTextPassword.getText().toString().equals("1234")){
                    Intent intent = new Intent(LoginActivity.this, AdminActivity.class);
                    startActivity(intent);
                    //Toast.makeText(LoginActivity.this, "Admin Activity", Toast.LENGTH_SHORT).show();
                }
                else if (autoCompleteTextViewUsername.getText().toString().equals("Moderator") && editTextPassword.getText().toString().equals("1234")){
                    Intent intent = new Intent(LoginActivity.this, ModeratorActivity.class);
                    startActivity(intent);
                    //Toast.makeText(LoginActivity.this, "Moderator Activity", Toast.LENGTH_SHORT).show();
                }
                else {
                    Toast.makeText(LoginActivity.this, "Wrong username or password", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }
}
