begin

declare @Tax numeric(8,2);
declare @MonthlyTax numeric(8,2);

declare @Basic numeric(8,2);
declare @Health_Allowance numeric(8,2);
declare @HouseRent numeric(8,2);
declare @Conveyance numeric(8,2);
declare @MealAllowance numeric(8,2);

declare @TaxM numeric(8,2);
declare @TaxR numeric(8,2);
declare @TaxRebate numeric(8,2);
declare @Amount numeric(8,2);

declare @first_slab bit;  
declare @second_slab bit;  
declare @third_slab bit;  
declare @fourth_slab bit;  
declare @fifth_slab bit;  
declare @sixth_slab bit;  

declare @Tin varchar(20);
declare @salary numeric(8,2);
declare @name varchar(20);
declare @grade char(1);
declare @Id int=1;


while(@Id<=3) 
begin
      select @name=EmpD.Employee_FirstName, @salary=sal.SalaryBasic,@Tin=EmpD.Employee_TIN  
      from  EmployeeDetails EmpD,Salary sal
      where EmpD.EmployeeId=sal.EmpId and @Id=EmpD.EmployeeId

	  	set @Tax=0;
        set @MonthlyTax=0;

	  if @Tin like '%A%'
	  begin
	    set @grade='A';

		set @Basic=30000;
		set @Health_Allowance=10000;
		set @HouseRent=15000;
		set @Conveyance=5000;
		set @MealAllowance=10000;

	  end
	  else if @Tin like '%B%'
	  begin
	    set @grade='B';
				
		set @Basic=50000;
		set @Health_Allowance=15000;
		set @HouseRent=20000;
		set @Conveyance=5000;
		set @MealAllowance=15000;
	  end 
	  else
	  begin
	    set @grade='c';
				
		set @Basic=80000;
		set @Health_Allowance=20000;
		set @HouseRent=25000;
		set @Conveyance=5000;
		set @MealAllowance=20000;
	  end 

	  --if(@grade='A')
	  --begin
	  --  print 'zen';
	  --end

	  --print @grade;

	  
	  
     set @Amount=@Basic+@Health_Allowance+@HouseRent+@Conveyance+@MealAllowance;
	-- print @Tax;
	 set @Amount=(2*0.3*@Basic)+(@Amount*12);


	 if(@Amount<300000)
	  begin
	  set @first_slab=1;
	  end

   else if(@Amount<400000)
   begin
   	  set @first_slab=1;
   	  set @second_slab=1;
   end

   else if(@Amount<700000)
   begin
   	  set @first_slab=1;
   	  set @second_slab=1;
	  set @third_slab=1;
   end

   else if(@Amount<1600000)
   begin
   	 set @first_slab=1;
   	 set @second_slab=1;
	 set @third_slab=1;
	 set @fourth_slab=1;
   end

   else 
   begin
   	 set @first_slab=1;
   	 set @second_slab=1;
	 set @third_slab=1;
	 set @fourth_slab=1;
     set @fifth_slab=1; 
   end

   --- now do calculation

    while (@Amount>0)
	 begin
	    if((@Amount>300000) and @first_slab=1)
		begin
		 set @Amount=@Amount-300000;
		 set @Tax=0;
		 set @first_slab=0;
		end

		else if((@Amount>100000) and @first_slab=0 and @second_slab=1)
		begin
		 set @Amount=@Amount-100000;
		 set @Tax=5000;
		 set @second_slab=0;
		end

		else if((@Amount>300000) and @first_slab=0 and @second_slab=0 and @third_slab=1)
		begin
		 set @Amount=@Amount-300000;
		 set @Tax=@Tax+30000;
		 set @third_slab=0;
		end

		else if((@Amount>0 and @Amount<=400000) and @first_slab=0 and @second_slab=0 and @third_slab=0 and @fourth_slab=1)
		begin
		 set @Tax=@Tax+(@Amount*0.15);
		 set @Amount=0;
		 set @fourth_slab=0;

		  break;
		end

		else if((@Amount>400000) and @first_slab=0 and @second_slab=0 and @third_slab=0 and @fourth_slab=1)
		begin
		 set @Tax=@Tax+60000;
		 set @Amount=@Amount-400000;
		 set @fourth_slab=0;
		end

	    else if((@Amount>0 and @Amount<=500000) and @first_slab=0 and @second_slab=0 and @third_slab=0 and @fourth_slab=0 and @fifth_slab=1)
		begin
		 set @Tax=@Tax+(@Amount*0.20);
		 set @Amount=0;
	     set @fifth_slab=0; 
	     set @sixth_slab=0;
		  break;
		end

		else if((@Amount>500000) and @first_slab=0 and @second_slab=0 and @third_slab=0 and @fourth_slab=0 and @fifth_slab=1)
		begin
		 set @Amount=@Amount-500000;
		 set @Tax=@Tax+100000;
		 set @fifth_slab=0; 
	     set @sixth_slab=0;
		end

		else 
		begin

		 set @Tax=@Tax+(@Amount*0.25);

		end
	 end

 -- after calculation update tds

 	  set @TaxM=0.15*@Tax;
	  set @TaxR=@Tax-@TaxM;
	 
	  set @MonthlyTax=@TaxR/12;
	  --print @TaxR;
	  --print @MonthlyTax;

	  update Salary set TaxTDS=@MonthlyTax where EmpId=@Id;

 -- do increement 

	  set @Id=@Id+1;
end
end