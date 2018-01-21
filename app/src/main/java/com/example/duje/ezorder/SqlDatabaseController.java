package com.example.duje.ezorder;

import android.content.Context;
import android.os.AsyncTask;
import android.os.StrictMode;
import android.util.Log;
import android.widget.Toast;

import java.sql.Array;
import java.sql.Connection;
import java.sql.DriverManager;
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

    public class GetFoodCategory extends AsyncTask<String,Void,List<String>>
    {
        UserActivity userActivity;
        Boolean isSuccess = false;

        List<String> listDataHeader;
        HashMap<String,List<String>> listHash;

        public GetFoodCategory(UserActivity userActivity) {
            this.userActivity = userActivity;
        }

        @Override
        protected List<String> doInBackground(String... args)
        {
            try {
                return readDatabase();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return new ArrayList<String>();
        }

        @Override
        protected void onPostExecute(List<String> r)
        {
            listDataHeader = r;
            listHash = new HashMap<>();

/*            listDataHeader.add("Entrees");
            listDataHeader.add("Pizza");
            listDataHeader.add("Dessert");
            listDataHeader.add("Drink");*/

            List<String> entrees = new ArrayList<>();
            entrees.add("$5        The Ghostie Sandwich");
            entrees.add("$7        Short Rib Ragu");
            entrees.add("$3        Braised Onion Sauce");
            entrees.add("$4        Creamy Mushroom Soup");
            entrees.add("$10      Beef Bourguignon");
            entrees.add("$4        Eggplant Parmesan");
            entrees.add("$5        Chicken Kiev");
            entrees.add("$5        Chicken Tamale Pie");
            entrees.add("$4        Beans and Greens Soup");
            entrees.add("$7        Rib Chili");
            entrees.add("$8        \"Greek\" Lamb with Orzo");
            entrees.add("$10      Linguine with Sardines, Fennel & Tomato");

            List<String> pizza = new ArrayList<>();
            pizza.add("$12      Balado Pizza");
            pizza.add("$12      Satay Pizza");
            pizza.add("$15      Tikka Chicken Pizza");
            pizza.add("$10      Pizza Margherita");
            pizza.add("$20      Pizza quattro stagioni");
            pizza.add("$15      Pizza Alla Napoletana (Napoli)");
            pizza.add("$13      Liguria Pizza");
            pizza.add("$15      Pizza Marinara");
            pizza.add("$17      Pizza Ai Quattro Formagi");
            pizza.add("$13      Pomodoro Pachina and Rughetta");
            pizza.add("$15      Pizza Romana");
            pizza.add("$25      Hawaiian Pizza (pineapple)");

            List<String> dessert = new ArrayList<>();
            dessert.add("$999 999 Million Dollar Pound Cake (doesn't cost million dollars)");
            dessert.add("$7        All-Time Favorite Chocolate Chip Cookies");
            dessert.add("$8        Classic Chess Pie");
            dessert.add("$8        Best Carrot Cake");
            dessert.add("$10      Pecan-Peach Cobbler");
            dessert.add("$7        Mom's Pecan Pie");
            dessert.add("$5        Summertime Peach Ice Cream");
            dessert.add("$7        Heavenly Key Lime Pie");
            dessert.add("$15      Chocolate-Red Velvet Layer Cake");
            dessert.add("$7        Classic Strawberry Shortcake");
            dessert.add("$10      Mississippi Mud Brownies (doesn't contain mud)");
            dessert.add("$15      Chocolate-Peanut Butter Mousse Cake");

            List<String> drink = new ArrayList<>();
            drink.add("$3        Coca-Cola");
            drink.add("$3        Sprite");
            drink.add("$3        Fanta");
            drink.add("$7        7-UP");
            drink.add("$2        Mineral water");
            drink.add("$3        Black tea");
            drink.add("$3        Mint tea");
            drink.add("$3        Green tea");
            drink.add("$4        Espresso");
            drink.add("$4        Americano");
            drink.add("$4        Latte");
            drink.add("$3        Ice Tea");

            listHash.put(listDataHeader.get(0),entrees);
            listHash.put(listDataHeader.get(1),pizza);
            listHash.put(listDataHeader.get(2),dessert);
            listHash.put(listDataHeader.get(3),drink);

            userActivity.InitData(listDataHeader, listHash);
        }


        private List<String> readDatabase()
                throws SQLException {
            listDataHeader = new ArrayList<String>();
            Statement stmt = null;
            try
            {
                Class.forName("net.sourceforge.jtds.jdbc.Driver");
                con = DriverManager.getConnection(db, un, pass);        // Connect to database

                String query = "SELECT [Id], [Name] FROM [FoodCategory]";
                stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(query);
                while (rs.next()) {
                    int Id = rs.getInt("Id");
                    String Name = rs.getString("Name");

                    listDataHeader.add(Name);
                }
            }
            catch (Exception ex)
            {
                isSuccess = false;
            } finally {
                if (stmt != null) {
                    stmt.close();
                }
            }

            return listDataHeader;
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
