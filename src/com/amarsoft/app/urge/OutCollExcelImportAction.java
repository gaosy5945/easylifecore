package com.amarsoft.app.urge;

import java.util.Map;

import com.amarsoft.app.als.dataimport.xlsimport.AbstractExcelImport;
import com.amarsoft.app.als.sys.tools.SYSNameManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.DBKeyHelp;

/**
 * 外包催收结果登记excel导入 新增CTP（COLL_TASK_PROCESS），更新CT(COLL_TASK),更新PTI（PUB_TASK_INFO）
 * 
 * @author T-liuzq
 *
 */
public class OutCollExcelImportAction extends AbstractExcelImport {
	private JBOTransaction trans;
	private boolean rollBack = false;
	BizObjectManager bmCT;
	BizObjectManager bmCTP;
	BizObjectManager bmPTI;

	@Override
	public void start(JBOTransaction tx) {
		try {
			trans = tx;
			bmCT = JBOFactory.getBizObjectManager("jbo.coll.COLL_TASK");
			bmCTP = JBOFactory
					.getBizObjectManager("jbo.coll.COLL_TASK_PROCESS");
			bmPTI = JBOFactory.getBizObjectManager("jbo.app.PUB_TASK_INFO");
			trans.join(bmCT);
			trans.join(bmCTP);
			trans.join(bmPTI);
		} catch (JBOException e) {
			ARE.getLog().error("", e);
		}
	}

	@Override
	public boolean process(Map<String, DataElement> excelMap) {
		boolean result = false;
		try {
			String TASKBATCHNO = excelMap.get("TASKBATCHNO").getString(); // 任务批次?
			String OBJECTNO = excelMap.get("OBJECTNO").getString(); // 借据编号
			String CUSTOMERNAME = excelMap.get("CUSTOMERNAME").getString(); // 客户姓名
			String BUSINESSTYPE = excelMap.get("BUSINESSTYPE").getString(); // 业务品种
			String PROCESSDATE = excelMap.get("PROCESSDATE").getString(); // 催收日期
			String COLLECTIONMETHOD = excelMap.get("COLLECTIONMETHOD")
					.getString(); // 催收方式
			// 证件类型，催收方式，催收结果，是需要取后面的代码的。
			if (COLLECTIONMETHOD.indexOf("_") != -1) {
				int index = COLLECTIONMETHOD.lastIndexOf("_") + 1;
				COLLECTIONMETHOD = COLLECTIONMETHOD.substring(index);
			}
			String CONTACTTELNO = excelMap.get("CONTACTTELNO") == null ? ""
					: excelMap.get("CONTACTTELNO").getString(); // 催收电话

			String CONTACTORNAME = excelMap.get("CONTACTORNAME") == null ? ""
					: excelMap.get("CONTACTORNAME").getString(); // 催收对象
			if (CONTACTORNAME.indexOf("_") != -1) {
				int index = CONTACTORNAME.lastIndexOf("_") + 1;
				CONTACTORNAME = CONTACTORNAME.substring(index);
			}
			String EXPLANATIONCODE = excelMap.get("EXPLANATIONCODE") == null ? ""
					: excelMap.get("EXPLANATIONCODE").getString(); // 客户解释
			if (EXPLANATIONCODE.indexOf("_") != -1) {
				int index = EXPLANATIONCODE.lastIndexOf("_") + 1;
				EXPLANATIONCODE = EXPLANATIONCODE.substring(index);
			}
			String CONTACTRESULT = excelMap.get("CONTACTRESULT").getString(); // 催收结果
			// 证件类型，催收方式，催收结果，是需要取后面的代码的。
			if (CONTACTRESULT.indexOf("_") != -1) {
				int index = CONTACTRESULT.lastIndexOf("_") + 1;
				CONTACTRESULT = CONTACTRESULT.substring(index);
			}
			String REMARK = excelMap.get("REMARK") == null ? "" : excelMap.get(
					"REMARK").getString(); // 备注
			String OPERATEDATE = excelMap.get("OPERATEDATE").getString(); // 委案日期
			String ACTUALFINISHDATE = excelMap.get("ACTUALFINISHDATE")
					.getString(); // 结案日期

			String INPUTUSERID = getCurPage().getParameter("InputUserId"); // 录入人id
			String INPUTORGID = CurUser.getOrgID(); // 录入机构id
			String INPUTDATE = DateHelper.getBusinessDate(); // 录入日期

			// 检查借据信息是否正确
			boolean bBDTrueFlag = checkBDTrueFlag(OBJECTNO, CUSTOMERNAME,
					BUSINESSTYPE);
			if (bBDTrueFlag) {

				// boolean isFlag = false;
				// 是否有该批次
				/*
				 * try{ BizObject bo =
				 * bmPTI.createQuery("  SERIALNO=:SERIALNO ")
				 * .setParameter("SERIALNO",
				 * TASKBATCHNO).getSingleResult(false); if(bo==null){ } else {
				 * isFlag = true; } } catch(Exception e){ e.printStackTrace(); }
				 */
				/*
				 * //生成PTI 更新PTI if(isFlag){ try{ BizObjectQuery boQPTI =
				 * bmPTI.createQuery(
				 * "update O set TASKTYPE=:TASKTYPE,OPERATEDATE=:OPERATEDATE,ACTUALFINISHDATE=:ACTUALFINISHDATE,STATUS=:STATUS,UPDATEDATE=:UPDATEDATE where SERIALNO=:SERIALNO "
				 * ); boQPTI.setParameter("SERIALNO", TASKBATCHNO);
				 * boQPTI.setParameter("TASKTYPE", "外包催收");//外包催收结果登记
				 * boQPTI.setParameter("OPERATEDATE", OPERATEDATE);
				 * boQPTI.setParameter("ACTUALFINISHDATE", ACTUALFINISHDATE);
				 * boQPTI.setParameter("STATUS","02");//状态：01-待处理，02-已处理
				 * boQPTI.setParameter("UPDATEDATE",DateHelper.getToday());
				 * boQPTI.executeUpdate(); //return true; } catch(Exception e){
				 * e.printStackTrace(); return false; } }else{ BizObject boPTI =
				 * bmPTI.newObject(); boPTI.setAttributeValue("SERIALNO",
				 * TASKBATCHNO); boPTI.setAttributeValue("TASKTYPE",
				 * "外包催收");//外包催收结果登记 boPTI.setAttributeValue("OPERATEDATE",
				 * OPERATEDATE); boPTI.setAttributeValue("ACTUALFINISHDATE",
				 * ACTUALFINISHDATE);
				 * //boPTI.setAttributeValue("STATUS","01");//状态：01-待处理，02-已处理
				 * boPTI.setAttributeValue("UPDATEDATE",DateHelper.getToday());
				 * bmPTI.saveObject(boPTI); }
				 */
				String sCTserialNo = "", operateUserID = "", operateOrgID = "";
				// 是否有该批次的该借据的催收信息
				try {
					BizObject bo = bmCT
							.createQuery(
									" OBJECTTYPE='jbo.acct.ACCT_LOAN' and OBJECTNO=:OBJECTNO  ")
							.setParameter("OBJECTTYPE", "jbo.acct.ACCT_LOAN")
							.setParameter("OBJECTNO", OBJECTNO)
							.getSingleResult(false);
					if (bo == null) {
					} else {
						sCTserialNo = bo.getAttribute("SERIALNO").getString();
						operateUserID = bo.getAttribute("OperateUserID")
								.getString();
						operateOrgID = bo.getAttribute("OperateorgID")
								.getString();
						if (operateOrgID == null || operateOrgID.length() == 0)
							operateOrgID = operateUserID;
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				if (StringX.isEmpty(sCTserialNo)) {
				} else {
					BizObjectQuery boQPTI = bmCT
							.createQuery("update O set STATUS=:STATUS,COLLECTIONMETHOD=:COLLECTIONMETHOD,"
									+ " COLLECTIONRESULT=:COLLECTIONRESULT,ENTRUSTDATE=:OPERATEDATE,ENTRUSTENDDATE=:ACTUALFINISHDATE,EXPLANATIONCODE=:EXPLANATIONCODE "
									+ " where OBJECTNO=:OBJECTNO and OBJECTTYPE=:OBJECTTYPE AND SERIALNO=:SERIALNO");
					boQPTI.setParameter("OBJECTTYPE", "jbo.acct.ACCT_LOAN");
					boQPTI.setParameter("OBJECTNO", OBJECTNO);
					boQPTI.setParameter("SERIALNO", sCTserialNo);
					boQPTI.setParameter("COLLECTIONMETHOD", "5");
					boQPTI.setParameter("COLLECTIONRESULT", CONTACTRESULT);
					boQPTI.setParameter("OPERATEDATE", OPERATEDATE);
					boQPTI.setParameter("ACTUALFINISHDATE", ACTUALFINISHDATE);
					boQPTI.setParameter("EXPLANATIONCODE", EXPLANATIONCODE);
					boQPTI.setParameter("STATUS", "2");// 催收信息状态：0-待催收，1-催收中，2-已催收
					boQPTI.executeUpdate();
				}

				// 生成CTP

				BizObject boCTP = bmCTP.newObject();
				boCTP.setAttributeValue("SERIALNO", DBKeyHelp.getSerialNo(
						"COLL_TASK_PROCESS", "SerialNo", ""));
				boCTP.setAttributeValue("TASKSERIALNO", sCTserialNo);
				boCTP.setAttributeValue("PROCESSDATE", PROCESSDATE);
				boCTP.setAttributeValue("PROCESSUSERID", operateUserID == null
						|| operateUserID.length() == 0 ? INPUTUSERID
						: operateUserID);
				boCTP.setAttributeValue("PROCESSORGID", operateOrgID == null
						|| operateOrgID.length() == 0 ? INPUTORGID
						: operateOrgID);
				boCTP.setAttributeValue("CONTACTORTYPE", CONTACTORNAME);
				boCTP.setAttributeValue("CONTACTTELNO", CONTACTTELNO);
				boCTP.setAttributeValue("CONTACTMETHOD", COLLECTIONMETHOD);
				boCTP.setAttributeValue("CONTACTRESULT", CONTACTRESULT);
				boCTP.setAttributeValue("INPUTDATE", INPUTDATE);
				boCTP.setAttributeValue("INPUTORGID", INPUTORGID);
				boCTP.setAttributeValue("INPUTUSERID", INPUTUSERID);
				boCTP.setAttributeValue("REMARK", REMARK);
				boCTP.setAttributeValue("EXPLANATIONCODE", EXPLANATIONCODE);
				bmCTP.saveObject(boCTP);

				result = true;
			} else
				result = false;
		} catch (Exception e) {
			rollBack = true;
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public void end() {
		if (rollBack)
			try {
				trans.rollback();
			} catch (JBOException e) {
				ARE.getLog("事务回滚出错");
			}
		else
			try {
				trans.commit();
			} catch (JBOException e) {
				ARE.getLog("事务提交出错");
			}
	}

	/**
	 * 检查借据信息是否正确
	 * 
	 * @param OBJECTNO
	 *            借据流水号
	 * @param CUSTOMERNAME
	 *            客户名称
	 * @param BUSINESSTYPE
	 *            业务品种
	 * @return
	 */
	public boolean checkBDTrueFlag(String OBJECTNO, String CUSTOMERNAME,
			String BUSINESSTYPE) {
		String sBDCustomerName = "";
		String sBDCustomerId = "";
		String sBDBusinessType = "";
		String sBusinessTypeName = "";
		boolean bBDTrueFlag = false;
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.acct.ACCT_LOAN");
			BizObject bo = bm.createQuery("  SERIALNO=:SERIALNO ")
					.setParameter("SERIALNO", OBJECTNO).getSingleResult(false);
			if (bo == null)
				this.writeLog("借据号" + OBJECTNO + "不存在！");
			else {
				sBDCustomerName = bo.getAttribute("CUSTOMERNAME").getString();
				sBDCustomerId = bo.getAttribute("CUSTOMERID").getString();
				sBDBusinessType = bo.getAttribute("BUSINESSTYPE").getString();
				/*sBusinessTypeName = NameManager
						.getBusinessName(sBDBusinessType);*/
				sBusinessTypeName = SYSNameManager.getProductName(sBDBusinessType);
				if ((CUSTOMERNAME.equals(sBDCustomerName) || CUSTOMERNAME == sBDCustomerName)
						&& (BUSINESSTYPE.equals(sBusinessTypeName) || BUSINESSTYPE == sBusinessTypeName))
					bBDTrueFlag = true;
				else
					this.writeLog("借据号" + OBJECTNO + "的客户名称或产品名称与系统中数据不一致！");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return bBDTrueFlag;
	}

}