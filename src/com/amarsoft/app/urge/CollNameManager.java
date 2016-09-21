package com.amarsoft.app.urge;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * ���չ����е��ֶ�ȡֵ
 * 
 * @author T-liuzq
 *
 */
public class CollNameManager {
	/**
	 * ���ݿͻ��ŵõ��ͻ�֤������
	 * 
	 * @param sCustomerID
	 * @return
	 */
	public static String getCustomerCertTypeNamer(String sCustomerID) {
		if (null == sCustomerID || StringX.isEmpty(sCustomerID))
			return "";
		String CustomerCertTypeNamer = "";
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
			BizObject bo = bm.createQuery(" O.CUSTOMERID=:CUSTOMERID ")
					.setParameter("CUSTOMERID", sCustomerID)
					.getSingleResult(false);
			if (bo == null) {
			} else {
				CustomerCertTypeNamer = bo.getAttribute("CERTTYPE").getString();
				if (StringX.isEmpty(CustomerCertTypeNamer))
					CustomerCertTypeNamer = "";
			}

			if (StringX.isEmpty(CustomerCertTypeNamer)
					|| null == CustomerCertTypeNamer) {
			} else
				CustomerCertTypeNamer = NameManager.getItemName(
						"CustomerCertType", CustomerCertTypeNamer);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return CustomerCertTypeNamer;
	}

	/**
	 * ���ݿͻ��ŵõ��ͻ�֤������
	 * 
	 * @param sCustomerID
	 * @return
	 */
	public static String getCustomerCertID(String sCustomerID) {
		if (null == sCustomerID || StringX.isEmpty(sCustomerID))
			return "";
		String CustomerCertID = "";
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
			BizObject bo = bm.createQuery(" O.CUSTOMERID=:CUSTOMERID ")
					.setParameter("CUSTOMERID", sCustomerID)
					.getSingleResult(false);
			if (bo == null) {
			} else {
				CustomerCertID = bo.getAttribute("CERTID").getString();
				if (StringX.isEmpty(CustomerCertID))
					CustomerCertID = "";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return CustomerCertID;
	}

	/**
	 * ���ݿͻ��ŵõ��ͻ���ϵ��ַ�����ܻ��ж����ַ
	 * 
	 * @param sCustomerID
	 * @return
	 */
	public static String getCustomerAddress(String sCustomerID) {
		if (null == sCustomerID || StringX.isEmpty(sCustomerID))
			return "";
		StringBuffer CustomerAddress = new StringBuffer();
		String CustomerAddress1 = "";
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.app.PUB_ADDRESS_INFO");
			List<BizObject> lst = bm
					.createQuery(
							" O.OBJECTNO=:CUSTOMERID and O.OBJECTTYPE='jbo.customer.CUSTOMER_INFO' order by O.serialNo desc")
					.setParameter("CUSTOMERID", sCustomerID)
					.getResultList(false);
			for (BizObject bo : lst) {
				String AddressType = NameManager.getItemName("AddressType", bo
						.getAttribute("ADDRESSTYPE").getString());
				String COUNTRY = NameManager.getItemName("CountryCode", bo
						.getAttribute("COUNTRY").getString());
				String PROVINCE = NameManager.getItemName("AreaCode", bo
						.getAttribute("PROVINCE").getString());
				String CITY = NameManager.getItemName("AreaCode", bo
						.getAttribute("CITY").getString());
				String ADDRESS1 = bo.getAttribute("ADDRESS1").getString();// �ء�����.append("(�С���)")
				String ADDRESS2 = bo.getAttribute("ADDRESS2").getString();// ������·.append("(�С���)")
				String ADDRESS3 = bo.getAttribute("ADDRESS3").getString();// ¥��.append("(�С���)")
				String ADDRESS4 = bo.getAttribute("ADDRESS4").getString();// ¥�㡢����.append("(�С���)")
				if (StringX.isEmpty(AddressType) || null == AddressType) {
				} else {
					CustomerAddress.append(AddressType).append(":");
					if (StringX.isEmpty(COUNTRY) || null == COUNTRY) {
					} else
						CustomerAddress.append(COUNTRY).append("(����)");// ���ҡ�����
					if (StringX.isEmpty(PROVINCE) || null == PROVINCE) {
					} else
						CustomerAddress.append(PROVINCE).append("(ʡ����)");// (ʡ����)
					if (StringX.isEmpty(CITY) || null == CITY) {
					} else
						CustomerAddress.append(CITY).append("(�С���)");// �С���
					CustomerAddress.append(StringX.isEmpty(ADDRESS1)
							|| null == ADDRESS1 ? "" : ADDRESS1);
					CustomerAddress.append(StringX.isEmpty(ADDRESS2)
							|| null == ADDRESS2 ? "" : ADDRESS2);
					CustomerAddress.append(StringX.isEmpty(ADDRESS3)
							|| null == ADDRESS3 ? "" : ADDRESS3);
					CustomerAddress.append(StringX.isEmpty(ADDRESS4)
							|| null == ADDRESS4 ? "" : ADDRESS4);
					CustomerAddress.append(",");
				}
			}
			CustomerAddress1 = CustomerAddress.toString();
			CustomerAddress1 = CustomerAddress1.replace("null", "");
			if (CustomerAddress1.endsWith(","))
				CustomerAddress1 = CustomerAddress1.substring(0,
						CustomerAddress1.length() - 1);
			if (StringX.isEmpty(CustomerAddress1) || CustomerAddress1 == "null")
				CustomerAddress1 = "";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return CustomerAddress1;
	}

	/**
	 * ���ݿͻ��ŵõ��ͻ��������� ���ܻ��ж����������
	 * 
	 * @param sCustomerID
	 * @return
	 */
	public static String getCustomerZipCode(String sCustomerID) {
		if (null == sCustomerID || StringX.isEmpty(sCustomerID))
			return "";
		StringBuffer CustomerZipCode = new StringBuffer();
		String CustomerZipCode1 = "";
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.app.PUB_ADDRESS_INFO");
			List<BizObject> lst = bm
					.createQuery(
							" O.OBJECTNO=:CUSTOMERID and O.OBJECTTYPE='jbo.customer.CUSTOMER_INFO' order by O.serialNo desc")
					.setParameter("CUSTOMERID", sCustomerID)
					.getResultList(false);
			for (BizObject bo : lst)
				if (lst.size() == 1)
					CustomerZipCode.append(bo.getAttribute("ZIPCODE")
							.getString());
				else {
					CustomerZipCode.append(bo.getAttribute("ZIPCODE")
							.getString());
					CustomerZipCode.append(",");
				}
			CustomerZipCode1 = CustomerZipCode.toString();
			CustomerZipCode1 = CustomerZipCode1.replace("null", "");
			if (CustomerZipCode1.endsWith(","))
				CustomerZipCode1 = CustomerZipCode1.substring(0,
						CustomerZipCode1.length() - 1);
			if (StringX.isEmpty(CustomerZipCode1) || CustomerZipCode1 == "null")
				CustomerZipCode1 = "";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return CustomerZipCode1;
	}

	/**
	 * ���ݿͻ��ŵõ��ͻ��Ա�
	 * 
	 * @param sCustomerID
	 * @return
	 */
	public static String getCustomerSexCode(String sCustomerID) {
		if (null == sCustomerID || StringX.isEmpty(sCustomerID))
			return "";
		String CustomerSex = "";
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.customer.IND_INFO");
			BizObject bo = bm.createQuery(" O.CUSTOMERID=:CUSTOMERID ")
					.setParameter("CUSTOMERID", sCustomerID)
					.getSingleResult(false);
			if (bo == null) {
			} else {
				CustomerSex = bo.getAttribute("SEX").getString();
				if (StringX.isEmpty(CustomerSex))
					CustomerSex = "";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return CustomerSex;
	}

	/**
	 * ���ݴ���ִ���˱�źʹ��շ�ʽȡ�ô���ִ����
	 * 
	 * @param sCustomerID
	 * @return
	 */
	public static String getCollUserName(String CollOperateUserID,
			String sCollectionMethod) {
		String sCollOperateUserName = "";
		try {
			BizObjectManager bm = null;
			BizObject bo = null;
			if ("5".equals(sCollectionMethod)) {
				bm = JBOFactory
						.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
				bo = bm.createQuery(" O.CUSTOMERID=:CUSTOMERID ")
						.setParameter("CUSTOMERID", CollOperateUserID)
						.getSingleResult(false);
				if (bo == null) {
				} else {
					sCollOperateUserName = bo.getAttribute("CUSTOMERNAME")
							.getString();
					if (StringX.isEmpty(sCollOperateUserName))
						sCollOperateUserName = "";
				}
			} else {
				bm = JBOFactory.getBizObjectManager("jbo.sys.USER_INFO");
				bo = bm.createQuery(" O.USERID=:USERID ")
						.setParameter("USERID", CollOperateUserID)
						.getSingleResult(false);
				if (bo == null) {
				} else {
					sCollOperateUserName = bo.getAttribute("USERNAME")
							.getString();
					if (StringX.isEmpty(sCollOperateUserName))
						sCollOperateUserName = "";
				}
				if ("".equals(sCollOperateUserName))
					sCollOperateUserName = CollOperateUserID;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sCollOperateUserName;
	}

	/**
	 * ���ݿͻ��ŵ绰����ȡ�����µ绰
	 * 
	 * @param sCustomerID
	 * @return
	 */
	public static String getCustomerTel(String sCustomerID, String sTelType) {
		if (null == sCustomerID || StringX.isEmpty(sCustomerID))
			return "";
		String CustomerTel = "";
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.customer.COLL_CUSTOMER_TEL");
			BizObject bo = bm
					.createQuery(
							" O.CUSTOMERID=:CUSTOMERID AND TELTYPE=:TELTYPE AND ISNEW='1' ")
					.setParameter("CUSTOMERID", sCustomerID)
					.setParameter("TELTYPE", sTelType).getSingleResult(false);
			if (bo == null) {
				bm = JBOFactory
						.getBizObjectManager("jbo.customer.CUSTOMER_TEL");
				bo = bm.createQuery(
						" O.CUSTOMERID=:CUSTOMERID AND TELTYPE=:TELTYPE AND ISNEW='1' ")
						.setParameter("CUSTOMERID", sCustomerID)
						.setParameter("TELTYPE", sTelType)
						.getSingleResult(false);
				if (bo == null) {
				} else {
					CustomerTel = bo.getAttribute("TELEPHONE").getString();
					if (StringX.isEmpty(CustomerTel))
						CustomerTel = "";
				}
			} else {
				CustomerTel = bo.getAttribute("TELEPHONE").getString();
				if (StringX.isEmpty(CustomerTel))
					CustomerTel = "";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return CustomerTel;
	}

	/**
	 * �������κŵõ�����ִ�й�˾
	 * 
	 * @param sCustomerID
	 * @return
	 */
	public static String getOperateName(String sTaskSerialNo) {
		if (null == sTaskSerialNo || StringX.isEmpty(sTaskSerialNo))
			return "";
		String CustomerOID = "";
		String CustomerOName = "";
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.app.PUB_TASK_INFO");
			BizObject bo = bm.createQuery(" O.SERIALNO=:SERIALNO ")
					.setParameter("SERIALNO", sTaskSerialNo)
					.getSingleResult(false);
			if (bo == null) {
			} else {
				CustomerOID = bo.getAttribute("OPERATEUSERID").getString();
				if (StringX.isEmpty(CustomerOName))
					CustomerOName = "";
			}
			bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
			bo = bm.createQuery(" O.CUSTOMERID=:CUSTOMERID ")
					.setParameter("CUSTOMERID", CustomerOID)
					.getSingleResult(false);
			if (bo == null) {
			} else {
				CustomerOName = bo.getAttribute("CUSTOMERNAME").getString();
				if (StringX.isEmpty(CustomerOName))
					CustomerOName = "";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return CustomerOName;
	}

	/**
	 * ���ݿͻ��ŵõ��ͻ��绰����
	 * 
	 * @param sCustomerID
	 * @return
	 */
	public static String getTelPhoneNumber(String sCustomerID) {
		if (null == sCustomerID || StringX.isEmpty(sCustomerID))
			return "";
		StringBuffer TelPhoneNumber = new StringBuffer();
		String TelPhoneNumber1 = "";
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.customer.CUSTOMER_TEL");
			List<BizObject> lst = bm
					.createQuery(
							" O.TELTYPE <>'010' and O.CUSTOMERID=:CUSTOMERID order by O.serialNo desc ")
					.setParameter("CUSTOMERID", sCustomerID)
					.getResultList(false);
			for (BizObject bo : lst) {
				TelPhoneNumber.append(
						NameManager.getItemName("CustomerTelType", bo
								.getAttribute("TELTYPE").getString())).append(
						":");
				String AREA = bo.getAttribute("AREA").getString();// ����
				String TELEPHONE = bo.getAttribute("TELEPHONE").getString();// �绰����
				String EXT = bo.getAttribute("EXT").getString();// �ֻ���
				if (StringX.isEmpty(AREA) || null == AREA) {
				} else
					TelPhoneNumber.append(AREA).append(" ");
				if (StringX.isEmpty(TELEPHONE) || null == TELEPHONE) {
				} else
					TelPhoneNumber.append(TELEPHONE).append(" ");
				if (StringX.isEmpty(EXT) || null == EXT) {
				} else
					TelPhoneNumber.append(EXT).append(" ");
				TelPhoneNumber.append(",");
			}

			TelPhoneNumber1 = TelPhoneNumber.toString();
			TelPhoneNumber1 = TelPhoneNumber1.replace("null", "");
			if (TelPhoneNumber1.endsWith(","))
				TelPhoneNumber1 = TelPhoneNumber1.substring(0,
						TelPhoneNumber1.length() - 1);
			if (StringX.isEmpty(TelPhoneNumber1) || TelPhoneNumber1 == "null")
				TelPhoneNumber1 = "";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return TelPhoneNumber1;
	}

	/**
	 * ���ݿͻ��ŵõ��ͻ��ֻ�����
	 * 
	 * @param sCustomerID
	 * @return
	 */
	public static String getCellPhoneNumber(String sCustomerID) {
		if (null == sCustomerID || StringX.isEmpty(sCustomerID))
			return "";
		StringBuffer CellPhoneNumber = new StringBuffer();
		String CellPhoneNumber1 = "";
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.customer.CUSTOMER_TEL");
			List<BizObject> lst = bm
					.createQuery(
							" O.TELTYPE ='010' and O.CUSTOMERID=:CUSTOMERID order by O.serialNo desc")
					.setParameter("CUSTOMERID", sCustomerID)
					.getResultList(false);
			for (BizObject bo : lst)
				if (lst.size() == 1)
					CellPhoneNumber.append(bo.getAttribute("TELEPHONE")
							.getString());
				else {
					CellPhoneNumber.append(bo.getAttribute("TELEPHONE")
							.getString());
					CellPhoneNumber.append(",");
				}

			CellPhoneNumber1 = CellPhoneNumber.toString();
			CellPhoneNumber1 = CellPhoneNumber1.replace("null", "");
			if (CellPhoneNumber1.endsWith(","))
				CellPhoneNumber1 = CellPhoneNumber1.substring(0,
						CellPhoneNumber1.length() - 1);
			if (StringX.isEmpty(CellPhoneNumber1) || CellPhoneNumber1 == "null")
				CellPhoneNumber1 = "";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return CellPhoneNumber1;
	}

	/**
	 * ���ݴ�����ˮ�� ��ȡ���е绰���ս��
	 * 
	 * @param sCollSerialNo
	 * @return
	 */
	public static String getHeadBankTelCollR(String sCollSerialNo) {
		String sReturnValues = "";
		if (null == sCollSerialNo || StringX.isEmpty(sCollSerialNo))
			return "";
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.coll.COLL_TASK_PROCESS");
			BizObject bo = bm
					.createQuery(
							"select O.CONTACTRESULT from O,jbo.sys.ORG_INFO OI where O.CONTACTMETHOD='2' and O.PROCESSORGID=OI.ORGID and OI.ORGLEVEL='1'  and O.TASKSERIALNO=:TASKSERIALNO ")
					.setParameter("TASKSERIALNO", sCollSerialNo)
					.getSingleResult(false);
			if (bo == null) {
			} else {
				String sReturnValuesTemp = bo.getAttribute("CONTACTRESULT")
						.getString();
				if (!StringX.isEmpty(sReturnValuesTemp))
					sReturnValues = NameManager.getItemName("CollectionResult",
							sReturnValuesTemp);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sReturnValues;
	}

	/**
	 * ���ݴ�����ˮ�� ��ȡ���е绰��������
	 * 
	 * @param sCollSerialNo
	 * @return
	 */
	public static String getHeadBankTelCollD(String sCollSerialNo) {
		String sReturnValues = "";
		if (null == sCollSerialNo || StringX.isEmpty(sCollSerialNo))
			return "";
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.coll.COLL_TASK_PROCESS");
			BizObject bo = bm
					.createQuery(
							" select O.PROCESSDATE from O,jbo.sys.ORG_INFO OI where O.CONTACTMETHOD='2' and O.PROCESSORGID=OI.ORGID and OI.ORGLEVEL='1' and O.TASKSERIALNO=:TASKSERIALNO ")
					.setParameter("TASKSERIALNO", sCollSerialNo)
					.getSingleResult(false);
			if (bo == null) {
			} else {
				sReturnValues = bo.getAttribute("PROCESSDATE").getString();
				if (StringX.isEmpty(sReturnValues))
					sReturnValues = "";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sReturnValues;
	}

	/**
	 * �����������κš�ȡֵ���� �õ���Ӧ�Ĵ��ձ���
	 * 
	 * @param sTaskBatchNo
	 *            �������κ�
	 * @param sGetType
	 *            ȡֵ���ͣ�0-������1-�Ѵ�������2-δ������,3-�ѻ�����
	 * @return
	 */
	public static String getCollCountNumber(String sTaskBatchNo, String sGetType) {
		String sReturnValues = "";
		String sWhereSql = "";
		int cnt = Integer.parseInt(sGetType);
		if (null == sTaskBatchNo || StringX.isEmpty(sTaskBatchNo))
			return "";
		if (null == sGetType || StringX.isEmpty(sGetType))
			return "";
		else
			switch (cnt) {
			case 0:
				sWhereSql = "  ";
				break;
			case 1:
				sWhereSql = " and STATUS='2' ";
				break;
			case 2:
				sWhereSql = " and STATUS <>'2' ";
				break;
			case 3:
				sWhereSql = " and exists (select 1 from jbo.acct.ACCT_PAYMENT_LOG apl where O.objectno = apl.loanserialno and apl.ACTUALPAYDATE >= O.operatedate) ";
				break;
			default:
				sWhereSql = " and 1=2 ";
				break;
			}
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.coll.COLL_TASK");
			BizObject bo = bm
					.createQuery(
							" select count(SERIALNO) from O where O.objecttype = 'jbo.acct.ACCT_LOAN' AND O.TASKBATCHNO=:TASKBATCHNO "
									+ sWhereSql)
					.setParameter("TASKBATCHNO", sTaskBatchNo)
					.getSingleResult(false);
			if (bo == null) {
			} else
				sReturnValues = String.valueOf(bo.getAttribute(25).getInt());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sReturnValues;
	}

	/**
	 * �����������κš�ȡֵ���� �õ���Ӧ�Ĵ������
	 * 
	 * @param sTaskBatchNo
	 *            �������κ�
	 * @param sGetType
	 *            ȡֵ���ͣ�0-����1-�Ѵ�����2-δ������3-�ѻ������
	 * @return
	 */
	public static String getCollAmountSum(String sTaskBatchNo, String sGetType) {
		String sReturnValues = "";
		String sWhereSql = "";
		int cnt = Integer.parseInt(sGetType);
		if (null == sTaskBatchNo || StringX.isEmpty(sTaskBatchNo))
			return "";
		if (null == sGetType || StringX.isEmpty(sGetType))
			return "";
		else
			switch (cnt) {
			case 0:
				sWhereSql = "  ";
				break;
			case 1:
				sWhereSql = " and STATUS='2' ";
				break;
			case 2:
				sWhereSql = " and STATUS <>'2' ";
				break;
			case 3:
				sWhereSql = "  ";// ���ȷ���ѻ���
				break;
			default:
				sWhereSql = " and 1=2 ";
				break;
			}
		try {
			if (sGetType == "3" || "3".equals(sGetType)) {
				BizObjectManager bm = JBOFactory
						.getBizObjectManager("jbo.acct.ACCT_PAYMENT_LOG");
				BizObject bo = bm
						.createQuery(
								" select sum(actualpayprincipalamt) from O  where O.loanserialno in(select cl.objectno from jbo.coll.COLL_TASK cl where cl.taskbatchno = :TASKBATCHNO )")
						.setParameter("TASKBATCHNO", sTaskBatchNo)
						.getSingleResult(false);
				if (bo == null) {
				} else
					sReturnValues = String.valueOf(bo.getAttribute(21)
							.getDouble());
			} else {
				BizObjectManager bm = JBOFactory
						.getBizObjectManager("jbo.coll.COLL_TASK");
				BizObject bo = bm
						.createQuery(
								" select sum(PRINCIPALAMOUNT) from O where O.TASKBATCHNO=:TASKBATCHNO "
										+ sWhereSql)
						.setParameter("TASKBATCHNO", sTaskBatchNo)
						.getSingleResult(false);
				if (bo == null) {
				} else
					sReturnValues = String.valueOf(bo.getAttribute(25)
							.getDouble());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sReturnValues;
	}

	/**
	 * ��ĳһ���� ����where���� �ĵ�select������ֵ
	 * 
	 * @param sTableValue
	 *            jbo ���� jbo.app.PUB_ADDRESS_INFO (OBJECTTYPE)
	 * @param sWhereValue
	 *            where���� OBJECTNO=''
	 * @param sSelValue
	 *            select ���� SERIALNO
	 * 
	 *            getTableColumnValue(OBJECTTYPE,"OBJECTNO='"+OBJECTNO+"'",
	 *            "SERIALNO")
	 */
	public static String getTableColumnValue(String sTableValue,
			String sWhereValue, String sSelValue) {
		String sReturnValues = "";
		if (null == sTableValue || StringX.isEmpty(sTableValue))
			return "";
		if (null == sWhereValue || StringX.isEmpty(sWhereValue))
			return "";
		if (null == sSelValue || StringX.isEmpty(sSelValue))
			return "";
		String CustomerCertID = "";
		try {
			BizObjectManager bm = JBOFactory.getBizObjectManager(sTableValue);
			BizObject bo = bm.createQuery(" sWhereValue ").getSingleResult(
					false);
			if (bo == null) {
			} else {
				CustomerCertID = bo.getAttribute("sSelValue").getString();
				if (StringX.isEmpty(CustomerCertID))
					CustomerCertID = "";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sReturnValues;
	}

	/**
	 * �����û�ID �õ����Ӧ���ʼ���ַ
	 * 
	 * @param sUserId
	 * @return
	 */
	public static String getUserMailAddr(String sUserId) {
		String sMailAddr = "";
		if (null == sUserId || StringX.isEmpty(sUserId))
			return "";
		StringBuffer sMailAddrList = new StringBuffer();
		try {
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.sys.USER_INFO");
			List<BizObject> lst = bm.createQuery("   O.USERID=:UserId   ")
					.setParameter("UserId", sUserId).getResultList(false);
			for (BizObject bo : lst)
				if (lst.size() == 1)
					sMailAddrList.append(bo.getAttribute("EMAIL").getString());
				else {
					sMailAddrList.append(bo.getAttribute("EMAIL").getString());
					sMailAddrList.append(",");
				}

			sMailAddr = sMailAddrList.toString();
			sMailAddr = sMailAddr.replace("null", "");
			if (sMailAddr.endsWith(","))
				sMailAddr = sMailAddr.substring(0, sMailAddr.length() - 1);
			if (StringX.isEmpty(sMailAddr) || sMailAddr == "null")
				sMailAddr = "";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sMailAddr;
	}

	/**
	 * ���ݿͻ�ID �õ����Ӧ���ʼ���ַ
	 * 
	 * @param sCustomerId
	 * @return
	 */
	public static String getCustomerMailAddr(String sCustomerId) {
		String sMailAddr = "";
		if (null == sCustomerId || StringX.isEmpty(sCustomerId))
			return "";
		StringBuffer sMailAddrList = new StringBuffer();
		try {
			/*
			 * BizObjectManager
			 * bm=JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_ECONTACT"
			 * ); List<BizObject> lst=bm.createQuery(
			 * " O.contacttype='01' and O.status='1' and O.customerid=:UserId   "
			 * ).setParameter("UserId",sCustomerId).getResultList(false);
			 * for(BizObject bo:lst){
			 * sMailAddrList.append(bo.getAttribute("ACCOUNTNO").getString());
			 * sMailAddrList.append(","); }
			 */
			BizObjectManager bm = JBOFactory
					.getBizObjectManager("jbo.customer.CUSTOMER_ECONTACT");
			BizObject bo = bm
					.createQuery(
							"O.contacttype='01' and O.status='1' and O.customerid=:UserId   ")
					.setParameter("UserId", sCustomerId).getSingleResult(false);
			if (bo == null) {
			} else
				sMailAddr = String.valueOf(bo.getAttribute(25).getDouble());
			sMailAddr = sMailAddrList.toString();
			sMailAddr = sMailAddr.replace("null", "");
			if (sMailAddr.endsWith(","))
				sMailAddr = sMailAddr.substring(0, sMailAddr.length() - 1);
			if (StringX.isEmpty(sMailAddr) || sMailAddr == "null")
				sMailAddr = "";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sMailAddr;
	}
}
