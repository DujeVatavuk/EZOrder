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
import java.util.LinkedHashMap;
import java.util.List;

/**
 * Created by duje on 21.1.2018..
 */

public class SqlDatabaseController {

    Connection con;

    // Declaring Server ip, username, database name and password
    String db = "jdbc:jtds:sqlserver://10.0.2.2:1433/EZOrder";//your IP and DB name
    //10.0.2.2:1433 ->localhost (1433 is standard port for MsSQL)
    String un = "test";//your username
    String pass = "test";//your password

    String z = "";
    Boolean isSuccess = false;

    Order order;

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

    public class GetInfoForAdmin extends AsyncTask<String,Void,Boolean>
    {
        AdminActivity adminActivity;
        Boolean isSuccess = false;

        /*List<FoodCategory> foodCategories;
        List<FoodItem> foodItems;
        HashMap<String,List<String>> listHash;*/
        List<ViewOrder> viewOrders;
        List<ViewOrderItem> viewOrderItems;
        HashMap<String,List<String>> listAdminHash;

        public GetInfoForAdmin(AdminActivity adminActivity) {
            this.adminActivity = adminActivity;
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
                adminActivity.CollectData(viewOrders, viewOrderItems);
            }
        }

        private void readDatabase()
                throws SQLException {
            /*foodCategories = new ArrayList<FoodCategory>();
            foodItems = new ArrayList<FoodItem>();*/
            viewOrders=new ArrayList<>();
            viewOrderItems=new ArrayList<>();
            Statement stmt = null;
            try
            {
                Class.forName("net.sourceforge.jtds.jdbc.Driver");
                con = DriverManager.getConnection(db, un, pass);        // Connect to database

                /*String query = "SELECT [Id], [Name] FROM [FoodCategories]";
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
                }*/

                String queryOrder = "SELECT TOP (500) [Id] ,[TableId] ,[Remark] ,[Ordered] ,[Processed] ,[OrderTotalPrice] FROM [dbo].[ViewOrders]  WHERE [Processed]=1 AND [OrderTotalPrice]!=0.00";
                stmt = con.createStatement();
                ResultSet rs = stmt.executeQuery(queryOrder);
                while (rs.next()) {
                    ViewOrder viewOrder=new ViewOrder();

                    viewOrder.Id=rs.getInt("Id");
                    viewOrder.TableId=rs.getInt("TableId");
                    viewOrder.Remark=rs.getString("Remark");
                    viewOrder.Ordered=rs.getDate("Ordered");
                    viewOrder.Processed=rs.getBoolean("Processed");
                    viewOrder.TotalPrice=rs.getFloat("OrderTotalPrice");

                    viewOrders.add(viewOrder);
                }

                String queryItem = "SELECT [OrderId] ,[FoodItemId] ,[Name] ,[Price] ,[Quantity] ,[TotalPrice] FROM [dbo].[ViewOrderItems]";
                stmt = con.createStatement();
                ResultSet rs1 = stmt.executeQuery(queryItem);
                while (rs1.next()) {
                    ViewOrderItem viewOrderItem=new ViewOrderItem();

                    viewOrderItem.OrderId=rs1.getInt("OrderId");
                    viewOrderItem.FoodItemId=rs1.getInt("FoodItemId");
                    viewOrderItem.Name=rs1.getString("Name");
                    viewOrderItem.Price=rs1.getFloat("Price");
                    viewOrderItem.Quantity=rs1.getInt("Quantity");
                    viewOrderItem.TotalPrice=rs1.getFloat("TotalPrice");

                    viewOrderItems.add(viewOrderItem);
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

    public class CreateOrder extends AsyncTask<String,String,String>
    {

        LoginActivity loginActivity;
        ConfirmationActivity confirmationActivity;
        Boolean isSuccess = false;

        public CreateOrder(LoginActivity loginActivity) {
            this.loginActivity = loginActivity;
            order = Order.getInstance();
        }

        //@Override
        public CreateOrder(ConfirmationActivity confirmationActivity) {
            this.confirmationActivity = confirmationActivity;
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
            /*try {
                if (isSuccess) {
                    Toast.makeText(this.loginActivity, "Order: " + String.valueOf(Id), Toast.LENGTH_LONG).show();
                }
            } catch (Exception e) {
                Log.e("fail login", e.getMessage());
            }
            try {
                if (isSuccess) {
                    Toast.makeText(this.confirmationActivity, "Order: " + String.valueOf(Id), Toast.LENGTH_LONG).show();
                }
            } catch (Exception e) {
                Log.e("fail confirmation", e.getMessage());
            }*/
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

    public class CreateOrderItem extends AsyncTask<String,String, String>
    {

        UserActivity userActivity;
        Boolean isSuccess = false;
        int FoodItemId = -1;

        public CreateOrderItem(UserActivity userActivity, int FoodItemId) {
            this.userActivity = userActivity;
            this.FoodItemId = FoodItemId;
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
                //Toast.makeText(this.userActivity , "OrderItem: " + String.valueOf(Id) , Toast.LENGTH_LONG).show();
            }
        }

        private String updateDatabase()
                throws SQLException {
            int Id = -1;
            try
            {
                Class.forName("net.sourceforge.jtds.jdbc.Driver");
                con = DriverManager.getConnection(db, un, pass);        // Connect to database

                String query = "INSERT INTO [dbo].[OrderItems] ([OrderId],[FoodItemId],[Quantity]) VALUES (?,?,1)";
                PreparedStatement ps = con.prepareStatement(query,Statement.RETURN_GENERATED_KEYS);
                ps.setInt(1, Order.getInstance().Id);
                ps.setInt(2, this.FoodItemId);
                ps.executeUpdate();
                ResultSet rs = ps.getGeneratedKeys();
                /*java.sql.RowId rowId_1 = rs.getRowId(1);*/
                while (rs.next()) {
                    // Get automatically generated key value
                    Id = rs.getInt(1);
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

    public class GetOrder extends AsyncTask<String,Void,Boolean>
    {
        ConfirmationActivity confirmationActivity;
        //ModeratorActivity moderatorActivity;
        Boolean isSuccess = false;

        ViewOrder viewOrder;
        List<ViewOrderItem> viewOrderItems;

        public GetOrder(ConfirmationActivity confirmationActivity) {
            this.confirmationActivity = confirmationActivity;
        }

        /*public GetOrder(ModeratorActivity moderatorActivity) {
            this.moderatorActivity = moderatorActivity;
        }*/

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
            if (isSuccess) {//odi pisem funkciju koja se izvrsava u confitmation activityu
                //userActivity.InitData(foodCategories, foodItems);
                confirmationActivity.WritePrice(viewOrder, viewOrderItems);//ode dolazi cijena
            }
        }

        private void readDatabase()
                throws SQLException {

            viewOrderItems = new ArrayList<ViewOrderItem>();

            try
            {
                Class.forName("net.sourceforge.jtds.jdbc.Driver");
                con = DriverManager.getConnection(db, un, pass);        // Connect to database

                String queryPrice = "SELECT TOP 1 [OrderTotalPrice] FROM [dbo].[ViewOrders] WHERE Id=(?)";
                PreparedStatement ps = con.prepareStatement(queryPrice);
                ps.setInt(1, Order.getInstance().Id);//valjda
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    viewOrder = new ViewOrder();
                    viewOrder.TotalPrice=rs.getFloat("OrderTotalPrice");
                }

                String queryOrder = "SELECT [OrderId], [FoodItemId], [Name], [Price], [Quantity], [TotalPrice] FROM [dbo].[ViewOrderItems] WHERE [OrderId]=(?)";
                PreparedStatement ps1 = con.prepareStatement(queryOrder);
                ps1.setInt(1, Order.getInstance().Id);//valjda
                ResultSet rs1 = ps1.executeQuery();
                while (rs1.next()) {
                    ViewOrderItem viewOrderItem = new ViewOrderItem();

                    viewOrderItem.OrderId=rs1.getInt("OrderId");
                    viewOrderItem.FoodItemId=rs1.getInt("FoodItemId");
                    viewOrderItem.Name=rs1.getString("Name");
                    viewOrderItem.Price=rs1.getFloat("Price");
                    viewOrderItem.Quantity=rs1.getInt("Quantity");
                    viewOrderItem.TotalPrice=rs1.getFloat("TotalPrice");

                    viewOrderItems.add(viewOrderItem);
                }

                isSuccess = true;
            }
            catch (Exception ex)
            {
                isSuccess = false;
            }
        }
    }

    public class ConfirmOrder extends AsyncTask<String,String,String>
    {

        ConfirmationActivity confirmationActivity;
        String Remark;
        Boolean isSuccess = false;


        public ConfirmOrder(ConfirmationActivity confirmationActivity, String remark) {
            this.confirmationActivity = confirmationActivity;
            this.Remark=remark;
            //order = Order.getInstance();
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
            /*if (isSuccess) {
                Toast.makeText(this.confirmationActivity, "Order: " + String.valueOf(Id), Toast.LENGTH_LONG).show();
            }*/
        }

        private String updateDatabase()
                throws SQLException {
            int Id = -1;
            //int TableId = 1; // hardkodirano
            try
            {
                Class.forName("net.sourceforge.jtds.jdbc.Driver");
                con = DriverManager.getConnection(db, un, pass);        // Connect to database
                /*
                String queryPrice = "SELECT TOP 1 [OrderTotalPrice] FROM [dbo].[ViewOrders] WHERE Id=(?)";
                PreparedStatement ps = con.prepareStatement(queryPrice);
                ps.setInt(1, Order.getInstance().Id);//valjda
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    viewOrder = new ViewOrder();
                    viewOrder.TotalPrice=rs.getFloat("OrderTotalPrice");
                }
                 */
                String queryOrdered = "UPDATE [dbo].[Orders] SET [Ordered] = getdate(), [Remark]=? WHERE [Id]=?";
                PreparedStatement ps = con.prepareStatement(queryOrdered);
                ps.setString(1, Remark);
                ps.setInt(2, Order.getInstance().Id);
                //trebat ce jos jedan prepard statement
                ps.executeUpdate();

                isSuccess = true;
            }
            catch (Exception ex)
            {
                isSuccess = false;
            }
            return String.valueOf(Id);
        }
    }

    public class ModerateOrder extends AsyncTask<String,Void,Boolean>
    {
        ModeratorActivity moderatorActivity;
        LinkedHashMap<String, String> OrderItemList;
        Boolean isSuccess = false;

        ViewOrder viewOrder;
        List<ViewOrder> viewOrders;

        ViewOrderItem viewOrderItem;
        List<ViewOrderItem> viewOrderItems;



        public ModerateOrder(ModeratorActivity moderatorActivity, LinkedHashMap<String, String> orderItemList) {
            this.moderatorActivity = moderatorActivity;
            this.OrderItemList=orderItemList;
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
            if (isSuccess) {//odi pisem funkciju koja se izvrsava u confitmation activityu
                //fillhashmap
                moderatorActivity.MetodaZaTestiranje(viewOrders);
                moderatorActivity.fillLinkedHashMap(viewOrderItems, OrderItemList);
            }
        }

        private void readDatabase()
                throws SQLException {

            viewOrders = new ArrayList<>();
            viewOrderItems = new ArrayList<>();

            try
            {
                Class.forName("net.sourceforge.jtds.jdbc.Driver");
                con = DriverManager.getConnection(db, un, pass);        // Connect to database

                /*String queryPrice = "SELECT TOP 1 [OrderTotalPrice] FROM [dbo].[ViewOrders] WHERE Id=(?)";
                PreparedStatement ps = con.prepareStatement(queryPrice);
                ps.setInt(1, Order.getInstance().Id);//valjda
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    viewOrder = new ViewOrder();
                    viewOrder.TotalPrice=rs.getFloat("OrderTotalPrice");
                }

                String queryOrder = "SELECT [OrderId], [FoodItemId], [Name], [Price], [Quantity], [TotalPrice] FROM [dbo].[ViewOrderItems] WHERE [OrderId]=(?)";
                PreparedStatement ps1 = con.prepareStatement(queryOrder);
                ps1.setInt(1, Order.getInstance().Id);//valjda
                ResultSet rs1 = ps1.executeQuery();
                while (rs1.next()) {
                    ViewOrderItem viewOrderItem = new ViewOrderItem();

                    viewOrderItem.OrderId=rs1.getInt("OrderId");
                    viewOrderItem.FoodItemId=rs1.getInt("FoodItemId");
                    viewOrderItem.Name=rs1.getString("Name");
                    viewOrderItem.Price=rs1.getFloat("Price");
                    viewOrderItem.Quantity=rs1.getInt("Quantity");
                    viewOrderItem.TotalPrice=rs1.getFloat("TotalPrice");

                    viewOrderItems.add(viewOrderItem);*/
                String queryPrice = "SELECT TOP 1 [Id] ,[TableId] ,[Remark] ,[Ordered] ,[Processed], [OrderTotalPrice] FROM [dbo].[ViewOrders] WHERE Id=(?)";
                PreparedStatement ps = con.prepareStatement(queryPrice);
                ps.setInt(1, Order.getInstance().Id);//valjda
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    viewOrder = new ViewOrder();

                    viewOrder.Id=rs.getInt("Id");
                    viewOrder.TableId=rs.getInt("TableId");
                    viewOrder.Remark=rs.getString("Remark");
                    viewOrder.Ordered=rs.getDate("Ordered");//pazit na format
                    viewOrder.Processed=rs.getBoolean("Processed");
                    viewOrder.TotalPrice=rs.getFloat("OrderTotalPrice");

                    viewOrders.add(viewOrder);
                }

                String queryOrder = "SELECT [OrderId], [FoodItemId], [Name], [Price], [Quantity], [TotalPrice] FROM [dbo].[ViewOrderItems] WHERE [OrderId]=(?)";
                PreparedStatement ps1 = con.prepareStatement(queryOrder);
                ps1.setInt(1, Order.getInstance().Id);//valjda
                ResultSet rs1 = ps1.executeQuery();
                while (rs1.next()) {
                    viewOrderItem = new ViewOrderItem();

                    viewOrderItem.OrderId = rs1.getInt("OrderId");
                    viewOrderItem.FoodItemId = rs1.getInt("FoodItemId");
                    viewOrderItem.Name = rs1.getString("Name");
                    viewOrderItem.Price = rs1.getFloat("Price");
                    viewOrderItem.Quantity = rs1.getInt("Quantity");
                    viewOrderItem.TotalPrice = rs1.getFloat("TotalPrice");

                    viewOrderItems.add(viewOrderItem);
                }

                isSuccess = true;
            }
            catch (Exception ex)
            {
                isSuccess = false;
            }
        }
    }

    public class ExecuteOrder extends AsyncTask<String,String,String>
    {

        ModeratorActivity moderatorActivity;
        Boolean isSuccess = false;


        public ExecuteOrder(ModeratorActivity moderatorActivity) {
            this.moderatorActivity = moderatorActivity;
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
            /*if (isSuccess) {
                Toast.makeText(this.confirmationActivity, "Order: " + String.valueOf(Id), Toast.LENGTH_LONG).show();
            }*/
        }

        private String updateDatabase()
                throws SQLException {
            int Id = -1;
            try
            {
                Class.forName("net.sourceforge.jtds.jdbc.Driver");
                con = DriverManager.getConnection(db, un, pass);        // Connect to database

                /*String queryOrdered = "UPDATE [dbo].[Orders] SET [Ordered] = getdate(), [Remark]=? WHERE [Id]=?";
                PreparedStatement ps = con.prepareStatement(queryOrdered);
                ps.setString(1, Remark);
                ps.setInt(2, Order.getInstance().Id);
                //trebat ce jos jedan prepard statement
                ps.executeUpdate();*/

                String queryExecute = "UPDATE [dbo].[Orders] SET [Processed]=1 WHERE [Id]=?";
                PreparedStatement ps = con.prepareStatement(queryExecute);
                ps.setInt(1, Order.getInstance().Id);
                ps.executeUpdate();

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
