CREATE TABLE [customer] (
    [cust_id] int  NOT NULL ,
    [cust_fName] varchar(50)  NOT NULL ,
    [cust_lName] varchar(50)  NOT NULL ,
    CONSTRAINT [PK_customer] PRIMARY KEY CLUSTERED (
        [cust_id] ASC
    )
);

CREATE TABLE [address] (
    [add_id] int  NOT NULL ,
    [delivery_address1] varchar(200)  NOT NULL ,
    [delivery_address2] varchar(200)  NULL ,
    [delivery_city] varchar(50)  NOT NULL ,
    [delivery_zipcoode] varchar(20)  NOT NULL ,
    CONSTRAINT [PK_address] PRIMARY KEY CLUSTERED (
        [add_id] ASC
    )
);

CREATE TABLE [order] (
    [row_id] int  NOT NULL ,
    [order_id] varchar(10)  NOT NULL ,
    [created_at] datetime  NOT NULL ,
    [item_id] int  NOT NULL ,
    [quantity] int  NOT NULL ,
    [cust_id] int  NOT NULL ,
    [delivery] bit NOT NULL ,
    [add_id] int  NOT NULL ,
    CONSTRAINT [PK_order] PRIMARY KEY CLUSTERED (
        [row_id] ASC
    ),
    CONSTRAINT [FK_order_customer] FOREIGN KEY ([cust_id]) REFERENCES [customer] ([cust_id]),
    CONSTRAINT [FK_order_address] FOREIGN KEY ([add_id]) REFERENCES [address] ([add_id])
);

CREATE TABLE [item] (
    [item_id] int  NOT NULL ,
    [sku] varchar(20)  NOT NULL ,
    [item_name] varchar(50)  NOT NULL ,
    [item_cat] varchar(50)  NOT NULL ,
    [item_size] varchar(20)  NOT NULL ,
    [item_price] decimal(5,2)  NOT NULL ,
    CONSTRAINT [PK_item] PRIMARY KEY CLUSTERED (
        [item_id] ASC
    )
);

CREATE TABLE [recipe] (
    [row_id] int  NOT NULL ,
    [recipe_id] varchar(20)  NOT NULL ,
    [item_id] int  NOT NULL ,
    [quantity] int  NOT NULL ,
    CONSTRAINT [PK_recipe] PRIMARY KEY CLUSTERED (
        [row_id] ASC
    ),
    CONSTRAINT [FK_recipe_item] FOREIGN KEY ([item_id]) REFERENCES [item] ([item_id])
);

CREATE TABLE [ingredient] (
    [ingredient_id] varchar(10)  NOT NULL ,
    [ingredient_name] varchar(200)  NOT NULL ,
    [ingredient_weight] int  NOT NULL ,
    [ingredient_measure] varchar(20)  NOT NULL ,
    [ingredient_price] decimal(5,2)  NOT NULL ,
    CONSTRAINT [PK_ingredient] PRIMARY KEY CLUSTERED (
        [ingredient_id] ASC
    )
);

CREATE TABLE [inventory] (
    [inv_id] int  NOT NULL ,
    [item_id] varchar(10)  NOT NULL ,
    [quantity] int  NOT NULL ,
    CONSTRAINT [PK_inventory] PRIMARY KEY CLUSTERED (
        [inv_id] ASC
    )
);

CREATE TABLE [staff] (
    [staff_id] varchar(10)  NOT NULL ,
    [first_name] varchar(50)  NOT NULL ,
    [last_name] varchar(50)  NOT NULL ,
    [position] varchar(30)  NOT NULL ,
    [hourly_rate] decimal(2,2)  NOT NULL ,
    CONSTRAINT [PK_staff] PRIMARY KEY CLUSTERED (
        [staff_id] ASC
    )
);

CREATE TABLE [shift] (
    [shift_id] varchar(10)  NOT NULL ,
    [day_of_week] datetime  NOT NULL ,
    [start_time] datetime  NOT NULL ,
    [end_time] datetime  NOT NULL ,
    CONSTRAINT [PK_shift] PRIMARY KEY CLUSTERED (
        [shift_id] ASC
    )
);

CREATE TABLE [rota] (
    [row_id] int  NOT NULL ,
    [rota_id] varchar(10)  NOT NULL ,
    [date] datetime  NOT NULL ,
    [shift_id] varchar(10)  NOT NULL ,
    [staff_id] varchar(10)  NOT NULL ,
    CONSTRAINT [PK_rota] PRIMARY KEY CLUSTERED (
        [row_id] ASC
    ),
    CONSTRAINT [FK_rota_shift] FOREIGN KEY ([shift_id]) REFERENCES [shift] ([shift_id]),
    CONSTRAINT [FK_rota_staff] FOREIGN KEY ([staff_id]) REFERENCES [staff] ([staff_id])
);

