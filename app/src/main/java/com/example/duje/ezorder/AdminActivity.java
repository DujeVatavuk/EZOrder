package com.example.duje.ezorder;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ExpandableListView;
import android.widget.ListView;
import android.widget.Toast;
import android.widget.ListAdapter;
//import com.example.duje.ezorder.AdminExpandableListAdapter;

import java.util.List;

public class AdminActivity extends AppCompatActivity {

    private Button ButtonExit;
    private ExpandableListView ExpandableListViewAdmin;
    private AdminExpandableListAdapter ExpandableListAdapterAdmin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_admin);

        ButtonExit=findViewById(R.id.ButtonExit);
        ExpandableListViewAdmin=findViewById(R.id.ExpandableListViewAdmin);

        SqlDatabaseController.GetInfoForAdmin getInfoForAdmin = new SqlDatabaseController().new GetInfoForAdmin(AdminActivity.this);
        getInfoForAdmin.execute();

        ButtonExit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(AdminActivity.this, LoginActivity.class);
                startActivity(intent);
            }
        });

    }

    public void CollectData(List<ViewOrder> viewOrders,
                            List<ViewOrderItem> viewOrderItems){

        // convert to List<String>
        ExpandableListAdapterAdmin = new AdminExpandableListAdapter(this, viewOrders, viewOrderItems);
        ExpandableListViewAdmin.setAdapter(ExpandableListAdapterAdmin);

        Toast.makeText(getApplicationContext(), "Order: " + String.valueOf(Order.getInstance().Id), Toast.LENGTH_SHORT).show();
    }
}
