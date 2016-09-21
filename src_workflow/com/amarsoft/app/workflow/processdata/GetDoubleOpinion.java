package com.amarsoft.app.workflow.processdata;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;

/**
 * 获取两个审批节点意见判断是否需要批复登记
 * @author 张万亮
 */

public class GetDoubleOpinion implements IProcess {

	public String process(List<BusinessObject> bos, BusinessObjectManager bomanager, String paraName, String dataType,BusinessObject otherPara) throws Exception {
		String phaseNo = otherPara.getString("PhaseNo");
		String flowSerialNo = otherPara.getString("FlowSerialNo");
		
		String[] fields = new String[]{"BusinessTerm","BusinessSum"};
		String[] fields1 = new String[]{"SegfromDate","SegfromStage","SegtoDate","SegtoStage","Segstages","SegNo","RateTermID","RateFloatType","RateFloat",
				"BusinessRate","RateMode","BaseRateType","BaseRate","RateType","RateUnit","OddInterestType","InterestType","InterestBaseFlag",
				"CompoundInterestFlag","BaseRateGrade","YearDays","RepriceType","RepriceTermUnit","RepriceTerm","RepriceDate","NEXTREPRICEDATE"};
		String[] fields2 = new String[]{"SEGFROMDATE","SEGFROMSTAGE","SEGTODATE","SEGTOSTAGE","SEGSTAGES","SEGNO","SEGNAME","SEGTERMFLAG","SEGTERM",
				"DEFAULTDUEDAY","GAINCYC","GAINAMOUNT","PAYMENTFREQUENCYTYPE","UPDATEINSTALAMTFLAG","SEGRPTAMOUNT","NEXTDUEDATE","TOTALPERIOD",
				"SEGRPTAMOUNTFLAG","SEGRPTPERCENT","SEGTERMUNIT","SEGINSTALMENTAMT","CURRENTPERIOD","SEGRPTBALANCE","FIRSTDUEDATE","INTERESTTYPE",
				"ODDINTERESTTYPE","PAYMENTFREQUENCYTERM","PAYMENTFREQUENCYTERMUNIT","DEFAULTDUEDAYTYPE"};
		String AfterRequirement = "",PutoutClause = "",baValue = "",fratValue = "",fValue = "",baratValue = "",frptValue = "",barptValue = "";
		PreparedStatement ba = null,Frat = null,BArat = null,Frpt = null,BArpt = null,ps = null,ps1 = null,ps2 = null,ap = null,ap1 = null,flowtask=null,ftPhaseActionType=null;
		ResultSet a = null,frat = null,barat = null,frpt = null,barpt = null,rs = null,rs1 = null,rs2 = null,app = null,app1 = null,flowtaskp=null,ftPhaseActionTypep=null;
		StringBuffer sb =  new StringBuffer(); 
		boolean flag = false;
		boolean flag1 = false;
		boolean baflag = true;
		boolean flag2 = false;
		boolean flag3 = true;
		boolean flag4 = false;
		int num = 0;
		int x = 0;
		int p = 0;
		String AfterRequirement1 = "";
		String PutoutClause1 = "";
		String PhaseActionType = "";
		String PhaseActionType1 = "";
		try
		{
			ps = bomanager.getConnection().prepareStatement("select * from FLOW_TASK where FlowSerialNo = ? and PhaseNo = ?");
			ps.setString(1, flowSerialNo);
			ps.setString(2, phaseNo);
			rs = ps.executeQuery();
			ps2 = bomanager.getConnection().prepareStatement("select * from FLOW_TASK where FlowSerialNo = ? and PhaseNo = ?");
			ps2.setString(1, flowSerialNo);
			ps2.setString(2, phaseNo);
			rs2 = ps2.executeQuery();
			while(rs2.next()){
				flag2 = true;
				flag4 = false;
				String taskSerialNo = rs2.getString("TaskSerialNo");
				ftPhaseActionType = bomanager.getConnection().prepareStatement("select * from FLOW_TASK  where TaskSerialNo = ?");
				ftPhaseActionType.setString(1, taskSerialNo);
				ftPhaseActionTypep = ftPhaseActionType.executeQuery();
				//判断两次审批意见是否一致
				while(ftPhaseActionTypep.next()){
					PhaseActionType = "";
					PhaseActionType = ftPhaseActionTypep.getString("PhaseActionType");
					if(PhaseActionType == null)PhaseActionType ="";
					if(p == 0){
						PhaseActionType1 = PhaseActionType;
						p++;
					}
					if(PhaseActionType.equals(PhaseActionType1)){
							flag4 = true;
					}
				}
				ftPhaseActionType.close();
				ftPhaseActionTypep.close();
				ap1 = bomanager.getConnection().prepareStatement("select * from BUSINESS_APPROVE BA where TaskSerialNo = ?");
				ap1.setString(1, taskSerialNo);
				app1 = ap1.executeQuery();
				//判断两个阶段的贷后管理要求和放款前落实条件是否一致
				while(app1.next()){
					AfterRequirement = app1.getString("AfterRequirement");
					PutoutClause = app1.getString("PutoutClause");
					if(AfterRequirement == null)AfterRequirement ="";
					if(PutoutClause == null)PutoutClause ="";
					if(num == 0){
						AfterRequirement1 = AfterRequirement;
						PutoutClause1 = PutoutClause;
						num++;
					}
					if(!AfterRequirement.equals(AfterRequirement1) || !PutoutClause.equals(PutoutClause1)){
						flag2 = false;
					}
				}
				ap1.close();
				app1.close();
			}
			ps2.close();
			rs2.close();
			while(rs.next()){
				if(!flag2)break;//如果两个阶段的贷后管理要求和放款前落实条件不一致就可以跳过一下判断提高效率
				String taskSerialNo = rs.getString("TaskSerialNo");
				flag = true;
				flag1 = true;
				flowtask = bomanager.getConnection().prepareStatement("select * from FLOW_TASK  where TaskSerialNo = ?");
				flowtask.setString(1, taskSerialNo);
				flowtaskp = flowtask.executeQuery();
				//判断意见说明是否有输入
				while(flowtaskp.next()){
					String PhaseOpinion = flowtaskp.getString("PhaseOpinion");
					if(!"".equals(PhaseOpinion) && PhaseOpinion != null){
						flag3 = false;
						break;
					}
				}
				flowtask.close();
				flowtaskp.close();
				ap = bomanager.getConnection().prepareStatement("select * from BUSINESS_APPROVE BA where TaskSerialNo = ?");
				ap.setString(1, taskSerialNo);
				app = ap.executeQuery();
				//判断贷后管理要求和放款前落实条件是否有人工输入
				while(app.next()){
					AfterRequirement = app.getString("AfterRequirement");
					PutoutClause = app.getString("PutoutClause");
					if(!"".equals(AfterRequirement) && AfterRequirement != null){
						int j=0;
						String[] AfterRequirements = AfterRequirement.split(",");
						for(int i = 0;i < AfterRequirements.length; i++){
							Item[] items = CodeCache.getItems("AfterRequirement");
							for(Item item : items)
							{
								if(AfterRequirements[i].equals(item.getItemName())){
									j++;
								}
							}
							j-=1;
							if(j!=i){//通过比较判断贷后管理要求是否有人工输入
								flag1 = false;
							}
						}
					}else{//如果贷后管理要求为空则不需要判断
						flag1 = true;
					}
					if(!"".equals(PutoutClause) && PutoutClause != null){
						int n=0;
						String[] PutoutClauses = PutoutClause.split(",");
						for(int i = 0;i < PutoutClauses.length; i++){
							Item[] items = CodeCache.getItems("PutoutClause");
							for(Item item : items)
							{
								if(PutoutClauses[i].equals(item.getItemName())){
									n++;
								}
							}
							n-=1;
							if(n!=i){//通过比较判断放款前落实条件是否有人工输入
								flag = false;
							}
						}
					}else{//如果放款前落实条件为空则不需要判断
						flag = true;
					}
				}
				ap.close();
				app.close();
				//获取BA的金额、期限、流水号
				ba = bomanager.getConnection().prepareStatement("select BA.BusinessTerm,BA.SerialNo,BA.BusinessSum from FLOW_OBJECT FO,BUSINESS_APPLY BA where FO.FlowSerialNo = ?"
						+ " and FO.OBJECTNO = BA.SerialNo and FO.ObjectType='jbo.app.BUSINESS_APPLY'");
				ba.setString(1, flowSerialNo);
				a = ba.executeQuery();
				while(a.next()){
					//获取BA对应的利率信息
					String serialNo = a.getString("SerialNo");
					BArat = bomanager.getConnection().prepareStatement("select RAT.* from BUSINESS_APPLY BA,ACCT_RATE_SEGMENT RAT where RAT.ObjectType = 'jbo.app.BUSINESS_APPLY' and "
							+ "RAT.ObjectNo = BA.SerialNo and BA.SerialNo = ? and BA.LOANRATETERMID = RAT.RateTermID ORDER BY RAT.SerialNo");
					BArat.setString(1, serialNo);
					barat = BArat.executeQuery();
					while(barat.next()){
						String rateTermID = barat.getString("RateTermID");
						//获取BUSINESS_APPROVE对应的利率信息
						Frat = bomanager.getConnection().prepareStatement("select BA.BusinessTerm,BA.BusinessSum,RAT.* from BUSINESS_APPROVE BA,ACCT_RATE_SEGMENT RAT where "
								+ "BA.TaskSerialNo = ? and RAT.ObjectType = 'jbo.app.BUSINESS_APPROVE' and RAT.ObjectNo = BA.SerialNo and RAT.RateTermID = ? ORDER BY RAT.SerialNo");
						Frat.setString(1, taskSerialNo);
						Frat.setString(2, rateTermID);
						frat = Frat.executeQuery();
						while(frat.next()){
							//判断批准金额和期限是否与申请的一致
							for(String field : fields){
								baValue = a.getString(field);
								fValue = frat.getString(field);
								if(baValue == null)baValue = "";
								if(fValue == null)fValue = "";
								if(!(fValue.equals(baValue))){
									baflag = false;
									break;
								}
							}
							//判断批准利率信息是否与申请的一致
							for(String field1 : fields1){
								baratValue = barat.getString(field1);
								fratValue = frat.getString(field1);
								if(baratValue == null)baratValue = "";
								if(fratValue == null)fratValue = "";
								if(!(baratValue.equals(fratValue)))
								{
									baflag = false;
									break;
								}
							}
						}
						Frat.close();
						frat.close();
					}
					BArat.close();
					barat.close();
					//获取BA对应的还款方式
					BArpt = bomanager.getConnection().prepareStatement("select RPT.* from BUSINESS_APPLY BA,ACCT_RPT_SEGMENT RPT where RPT.ObjectType = 'jbo.app.BUSINESS_APPLY' and "
							+ "RPT.ObjectNo = BA.SerialNo and BA.SerialNo = ? ORDER BY RPT.SerialNo");
					BArpt.setString(1, serialNo);
					barpt = BArpt.executeQuery();
					while(barpt.next()){
						String segRptTermID = barpt.getString("SegRptTermID");
						String rptTermID = barpt.getString("RptTermID");
						if(segRptTermID == null)segRptTermID = "";
						//获取BUSINESS_APPROVE对应的还款方式信息
						Frpt = bomanager.getConnection().prepareStatement("select RPT.* from BUSINESS_APPROVE BA,ACCT_RPT_SEGMENT RPT where RPT.ObjectType = 'jbo.app.BUSINESS_APPROVE' "
								+ "and RPT.ObjectNo = BA.SerialNo and BA.TaskSerialNo = ? and RPT.SegRptTermID = ? and RPT.RptTermID = ? ORDER BY RPT.SerialNo");
						Frpt.setString(1, taskSerialNo);
						Frpt.setString(2, segRptTermID);
						Frpt.setString(3, rptTermID);
						frpt = Frpt.executeQuery();
						//判断批准还款方式信息是否与申请的一致
						while(frpt.next()){
							for(String field2 : fields2){
								barptValue = barpt.getString(field2);
								frptValue = frpt.getString(field2);
								if(barptValue == null)barptValue = "";
								if(frptValue == null)frptValue = "";
								if(!(barptValue.equals(frptValue)))
								{
									baflag = false;
									break;
								}
							}
						}
						Frpt.close();
						frpt.close();
					}
					BArpt.close();
					barpt.close();
				}
				ba.close();
				a.close();
				if(!flag || !baflag || !flag1 || !flag2 || !flag3 || !flag4){
					x++;
				}
			}
			ps.close();
			rs.close();
			String taskSerialNo = otherPara.getString("TaskSerialNo");
			ps1 = bomanager.getConnection().prepareStatement("select * from FLOW_TASK where TaskSerialNo = ?");
			ps1.setString(1, taskSerialNo);
			rs1 = ps1.executeQuery();
			String value1 = "";
			if(!flag2){
				value1 = "1";
			}else if(x == 0){           //如果两个阶段的审批意见中的贷后管理要求和放款前落实条件完全一样（且没有手工输入）
				value1 = "0";     //并且批准的金额、利率、还款方式与申请的完全一致则不需要进行批复登记
			}
			else{
				value1 = "1";
			}
			while(rs1.next()){
				sb.append("<task");
				sb.append(rs1.getString("TaskSerialNo"));
				sb.append(">");
				sb.append(value1);
				sb.append("</task");
				sb.append(rs1.getString("TaskSerialNo"));
				sb.append(">"); 
			}
			ps1.close();
			rs1.close();
		}finally
		{
			try{if(rs != null ) rs.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(rs1 != null ) rs1.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(rs2 != null ) rs2.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(ps != null ) ps.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(ps1 != null ) ps1.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(ps2 != null ) ps2.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(ba != null ) ba.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(Frat != null ) Frat.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(BArat != null ) BArat.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(Frpt != null ) Frpt.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(BArpt != null ) BArpt.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(ap != null ) ap.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(ap1 != null ) ap1.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(a != null ) a.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(frat != null ) frat.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(barat != null ) barat.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(frpt != null ) frpt.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(barpt != null ) barpt.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(app != null ) app.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(app1 != null ) app1.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(flowtask != null ) flowtask.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(flowtaskp != null ) flowtaskp.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(ftPhaseActionType != null ) ftPhaseActionType.close();}catch(Exception ex){ex.printStackTrace();}
			try{if(ftPhaseActionTypep != null ) ftPhaseActionTypep.close();}catch(Exception ex){ex.printStackTrace();}
		}
		return sb.toString();
	}

}
