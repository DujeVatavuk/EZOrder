package com.example.duje.ezorder;

import android.content.Context;
import android.os.AsyncTask;
import android.os.StrictMode;
import android.util.Log;
import android.widget.Toast;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by duje on 21.1.2018..
 */

public class SqlDatabaseController {

    Connection con;

    // Declaring Server ip, username, database name and password
    String db = "jdbc:jtds:sqlserver://10.0.2.2:1433/EZOrder";
    String un = "test";
    String pass = "test";

    String z = "";
    Boolean isSuccess = false;

    Order order;

    public class CheckLogin extends AsyncTask<String,String,String>
    {
        Context someContext;
        String z = "";
        Boolean isSuccess = false;

        public CheckLogin(Context SomeContext) {
            this.someContext = SomeContext;
        }

        @Override
        protected void onPostExecute(String r)
        {
            if(isSuccess)
            {
                Toast.makeText(this.someContext , "Login Successfull" , Toast.LENGTH_LONG).show();
                //finish();
            }
        }
        @Override
        protected String doInBackground(String... args)
        {
            return readDatabase();
        }

        public String readDatabase() {
            try
            {
                Class.forName("net.sourceforge.jtds.jdbc.Driver");
                con = DriverManager.getConnection(db, un, pass);        // Connect to database
                if (con == null)
                {
                    z = "Check Your Internet Access!";
                }
                else
                {
                    //Toast.makeText(MainActivity.this , "Conn no es null" , Toast.LENGTH_LONG).show();
                    // Change below query according to your own database.
                    String query = "select * from Producttbl";
                    Statement stmt = con.createStatement();
                    ResultSet rs = stmt.executeQuery(query);
                    if(rs.next())
                    {
                        z = "Login successful";
                        isSuccess=true;
                        con.close();
                    }
                    else
                    {
                        z = "Invalid Credentials!";
                        isSuccess = false;
                    }
                }
            }
            catch (Exception ex)
            {
                isSuccess = false;
                z = ex.getMessage();
            }
            return z;
        }
    }

    public class GetFoodCategory extends AsyncTask<String,Void,Boolean>
    {
        UserActivity userActivity;
        Boolean isSuccess = false;

        List<FoodCategory> foodCategories;
        List<FoodItem> foodItems;
        HashMap<String,List<String>> listHash;

        public GetFoodCategory(UserActivity userActivity) {
            this.userActivity = userActivity;
        }

        @Override
        protected Boolean doInBackground(String... args)
        {
            try {
                readDatabase();
            } catch (SQLException e) {
                e.printStackTrace();
            }

            return isSuccess;
        }

        @Override
        protected void onPostExecute(Boolean isSuccess)
        {
            if (isSuccess) {
                userActivity.InitData(foodCategories, foodItems);
            }
        }

        private void readDatabase()
                throws SQLException {
            foodCategories = new ArrayList<FoodCategory>();
            foodItems = new ArrayList<FoodItem>();
            Statement stmt = null;
            try
            {
                Class.forName("net.sourceforge.jtds.jdbc.Driver");
                con = DriverManager.getConnection(db, un, pass);        // Connect to database

                String query = "SELECT [Id], [Name] FROM [FoodCategories]";
                stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(query);
                while (rs.next()) {
                    FoodCategory foodCategory = new FoodCategory();
                    foodCategory.Id = rs.getInt("Id");
                    foodCategory.Name = rs.getString("Name");

                    foodCategories.add(foodCategory);
                }

                String queryItems = "SELECT [Id], [FoodCategoryId], [Name], [Price] FROM [dbo].[FoodItems]";
                ResultSet rsItems = stmt.executeQuery(queryItems);
                while (rsItems.next()) {
                    FoodItem foodItem = new FoodItem();
                    foodItem.Id = rsItems.getInt("Id");
                    foodItem.FoodCategoryId = rsItems.getInt("FoodCategoryId");
                    foodItem.Name = rsItems.getString("Name");
                    foodItem.Price = rsItems.getFloat("Price");

                    foodItems.add(foodItem);
                }

                isSuccess = true;
            }
            catch (Exception ex)
            {
                isSuccess = false;
            } finally {
                if (stmt != null) {
                    stmt.close();
                }
            }
        }
    }

    public class CreateOrder extends AsyncTask<String,String, String>
    {

        LoginActivity loginActivity;
        Boolean isSuccess = false;

        public CreateOrder(LoginActivity loginActivity) {
            this.loginActivity = loginActivity;
            order = Order.getInstance();
        }

        @Override
        protected String doInBackground(String... args)
        {
            try {
                return updateDatabase();
            } catch (SQLException e) {
                e.printStackTrace();
            }

            return "-1";
        }

        @Override
        protected void onPostExecute(String Id)
        {
            if (isSuccess) {
                Toast.makeText(this.loginActivity , "Order: " + String.valueOf(Id) , Toast.LENGTH_LONG).show();
            }
        }

        private String updateDatabase()
                throws SQLException {
            int Id = -1;
            int TableId = 1; // hardkodirano
            try
            {
                Class.forName("net.sourceforge.jtds.jdbc.Driver");
                con = DriverManager.getConnection(db, un, pass);        // Connect to database

                String query = "INSERT INTO [dbo].[Orders] ([TableId]) VALUES (?)";
                PreparedStatement ps = con.prepareStatement(query,Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, TableId);
                ps.executeUpdate();
                ResultSet rs = ps.getGeneratedKeys();
                /*java.sql.RowId rowId_1 = rs.getRowId(1);*/
                while (rs.next()) {
                    // Get automatically generated key value
                    Order.getInstance().Id = rs.getInt(1);
                }
                rs.close();
                isSuccess = true;
            }
            catch (Exception ex)
            {
                isSuccess = false;
            }
            return String.valueOf(Id);
        }
    }

    public Connection connectionclass(String user, String password, String database, String server)
    {
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);
        Connection connection = null;
        String ConnectionURL = null;
        try
        {
            Class.forName("net.sourceforge.jtds.jdbc.Driver");
            ConnectionURL = "jdbc:jtds:sqlserver://" + server + database + ";user=" + user+ ";password=" + password + ";";
            connection = DriverManager.getConnection(ConnectionURL);
        }
        catch (SQLException se)
        {
            Log.e("error here 1 : ", se.getMessage());
        }
        catch (ClassNotFoundException e)
        {
            Log.e("error here 2 : ", e.getMessage());
        }
        catch (Exception e)
        {
            Log.e("error here 3 : ", e.getMessage());
        }
        return connection;
    }
}
