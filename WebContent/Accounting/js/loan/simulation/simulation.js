/**
 *������ѯ���js
 * 
 * xyqu 2014/07/15
 *  
 */

function calcLoanRateTermID(objectType,objectNo){
			var obj = $('#RatePart');
			var obj_dw = document.getElementById('RatePart');
			if(typeof(obj) == "undefined" || obj == null || typeof(obj_dw) == "undefined" || obj_dw == null) {
				return;
			}

			//����������
			var sLoanRateTermID = getItemValue(0,getRow(),"LoanRateTermID");
			if(typeof(sLoanRateTermID) == "undefined" || sLoanRateTermID==null||sLoanRateTermID.length == 0){
				return;
			}
			
			//����
			var currency = getItemValue(0,getRow(),"BusinessCurrency");
			if(typeof(currency) == "undefined" ||currency==null|| currency.length == 0){
				currency = getItemValue(0,getRow(),"Currency");
			 	}
			if(typeof(currency) == "undefined" || currency==null||currency.length == 0){
				currency = "";
			}
			
			//�̶�����
			if(sLoanRateTermID == "RAT002"){
				//setItemValue(0,getRow(),"RepriceType","7");AdjustRateType
				setItemValue(0,getRow(),"RepriceType","7");
				try{
					//setItemDisabled(0,getRow(),"RepriceType",true);
					setItemDisabled(0,getRow(),"RepriceType",true);
				}
				catch(e){}
			}else{
				try{
					setItemDisabled(0,getRow(),"RepriceType",false);
				}
				catch(e){}
			}
			
			//����
			var termMonth=getItemValue(0,getRow(),"TermMonth");
			var termDay=getItemValue(0,getRow(),"TermDay");
			if(!(typeof(termDay) == "undefined" || termDay==null||termDay.length == 0||termDay==0)){
				termMonth=parseFloat(termMonth)+1;
			}
			
			
			OpenComp("BusinessTermView","/Accounting/LoanSimulation/LoanTerm/BusinessTermView.jsp","Status=0&ToInheritObj=y&termMonth="+termMonth+"&ObjectType="+objectType+"&ObjectNo="+objectNo+"&TermID="+sLoanRateTermID+"&Currency="+currency,"RatePart","");
		}