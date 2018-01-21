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

    private AutoCompleteTextView AutoCompleteTextViewUsername;
    private EditText EditTextPassword;
    private Button ButtonNoSignIn;
    private Button ButtonSignIn;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        AutoCompleteTextViewUsername=findViewById(R.id.AutoCompeteTextViewUsername);
        EditTextPassword=findViewById(R.id.EditTextPassword);
        ButtonNoSignIn=findViewById(R.id.ButtonNoSignIn);
        ButtonSignIn=findViewById(R.id.ButtonSignIn);

        ButtonNoSignIn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Intent intent = new Intent(LoginActivity.this, UserActivity.class);
                startActivity(intent);

            }
        });

        ButtonSignIn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                /*
                SqlDatabaseController.CheckLogin checkLogin = new SqlDatabaseController().new CheckLogin(LoginActivity.this);
                checkLogin.execute("usr","pwd");
                */

                if (AutoCompleteTextViewUsername.getText().toString().equals("Admin") && EditTextPassword.getText().toString().equals("1234")){
                    Intent intent = new Intent(LoginActivity.this, AdminActivity.class);
                    startActivity(intent);
                    //Toast.makeText(LoginActivity.this, "Usli ste u Admin Activity", Toast.LENGTH_SHORT).show();
                }
                else if (AutoCompleteTextViewUsername.getText().toString().equals("Moderator") && EditTextPassword.getText().toString().equals("1234")){
                    Intent intent = new Intent(LoginActivity.this, ModeratorActivity.class);
                    startActivity(intent);
                    //Toast.makeText(LoginActivity.this, "Usli ste u Moderator Activity", Toast.LENGTH_SHORT).show();
                }
                else {
                    Toast.makeText(LoginActivity.this, "Unjeli ste krivi username ili password", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }
}
