import pandas as pd

IBM = pd.read_csv("IBM_Stocks.csv")

# Converting time column to datetime
IBM['Date'] = pd.to_datetime(IBM['Date'])


# My goal with this data set is to display my modeling skills 
# and abilities. I want to use this set to show how I can take raw data, run
# tests, create a reliable and statistically significant model, and accurately
# predict the following days ADJ closing price.

# I will start by creating a predicted "target" column for comparison to my 
# models predicted price and the actual closing price
IBM = IBM.sort_values('Date') # assuring organized accurately by date
IBM['Target'] = IBM['Adj Close'].shift(-1)
print(IBM.tail())
print(IBM.shape)
# I see our last row has a NaN value, which is expected because we have placed 
# our ADJ close for the following day under the Target column we created, so
# the last added value does not have the following days ADJ Close because it has
# not yet happened. To keep our data clean from error, we will remove this row:
IBM = IBM.dropna()
print(IBM.tail())

print(IBM.shape) # checking rows after to assure no others were removed by accident
# and I can confirm only the one row was removed


# To begin the model creation process, I am going to select only the variables
# I see necessary to creating our model:
predictors = ['Open', 'High', 'Low', 'Close', 'Adj Close', 'Volume']
x = IBM[predictors]
y = IBM['Target'] # our prediction column

# It is now important that I run a few tests on the data to accurately select
# a model for our data type as to avoid high MSE's and general innacuracy's.
import matplotlib.pyplot as plt # I will model for patterns and outliers
plt.figure()
plt.plot(IBM['Date'], IBM['Adj Close'])
plt.title('IBM Adj Close Over Time')
plt.xlabel('Date')
plt.ylabel('Price')
plt.show()
# Looking at the plot we can see that IBM Adj Close has drastically increased 
# overtime, with steep increases right around the early 2000's and 2024. There
# are more gradual increases around 2008 - 2014 and 2020-2024/ Up until the late
# 1990's there seems to have been very low Adj Close with this stock.

# Before running any tests and designing our model, I first want to clean the
# data up a bit. 
# I will first remove missing values if present
print(IBM.isnull().sum())
IBM = IBM.dropna() 
# And I then will remove any duplicate rows
IBM = IBM.drop_duplicates()
print(IBM.dtypes) # checking variables are assigned to their correct types
IBM = IBM.sort_values('Date') # checking assortment of data

from sklearn.linear_model import LinearRegression
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error, r2_score

models = {
    "Linear Regression": LinearRegression(),
    "Random Forest": RandomForestRegressor(n_estimators=100, random_state=42)
}

for name, model in models.items():
    model.fit(X_train, y_train)
    preds = model.predict(X_test)
    mse = mean_squared_error(y_test, preds)
    r2 = r2_score(y_test, preds)
    print(f"{name}: MSE={mse:.4f}, R²={r2:.4f}")
