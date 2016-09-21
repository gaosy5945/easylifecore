package com.amarsoft.app.oci;

import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;
import java.nio.charset.CodingErrorAction;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.Map.Entry;
import java.util.regex.Pattern;

import org.jdom.Attribute;
import org.jdom.Element;

import com.amarsoft.app.oci.bean.Field;
import com.amarsoft.app.oci.bean.Message;
import com.amarsoft.app.oci.exception.DataFormatException;
import com.amarsoft.app.oci.exception.ExceptionFactory;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.are.ARE;

/**
 * <p>ʵʱ�ӿ�ҵ��������</p>
 * @author xjzhao
 *
 */
public class Tools {
	/**
	 * ���ַ������ֽ�λ���ضϣ��ضϺ�����Ļ����ַ������ԣ�����ʵ�ʷ��ؿ��ܱ������ĳ���С
	 * @param value		Ҫ�ضϵ��ַ���
	 * @param charset	����
	 * @param bytelength �����ضϺ���ֽ���
	 * @return	�ضϺ���ַ���
	 */
	public static String truncate(String value, String charset, int bytelength){
		try {
			ByteBuffer buffer = Charset.forName(charset).encode(value);					
			if(buffer.capacity() <= bytelength){	//����ͱ�lengthС������ԭֵ
				return value;
			}else{	
				buffer.limit(bytelength);	//��ȡ bytelength λ
				CharsetDecoder decoder= Charset.forName(charset).newDecoder();
				decoder.onMalformedInput(CodingErrorAction.IGNORE);		//���Ľض�1/2��ʣ�����
				decoder.onUnmappableCharacter(CodingErrorAction.IGNORE);				
				return decoder.decode(buffer).toString();
			}
		} catch (Exception e) {
			ARE.getLog().error("��ַ�ضϱ���",e);
		}
		return "";
	}
	/**
	 * <p>����Ϣ������л����ĸ�ʽУ��</p>
	 * @param message
	 * @param charSet
	 * @throws OCIException
	 */
	public static void checkMessage(Message message, String charSet, String dataUnit) throws OCIException {
		try{

			Field[] msgFileds = message.getFields();

			for (int i = 0; i < msgFileds.length; i++) {
				if(msgFileds[i].getFieldValue() == null) 
					throw new DataFormatException(" @" + msgFileds[i].getFieldTag() + " "
							+ msgFileds[i].getDescription()
							+ " Field value can not be null"); 
				
				if (msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_INT)) {
					if (!Pattern.matches("[0-9]*", msgFileds[i].getFieldValue()))
						throw new DataFormatException(" @" + msgFileds[i].getFieldTag() + " "
								+ msgFileds[i].getDescription() + "[" + msgFileds[i].getFieldValue() + "]"
								+ " Field value not match int format");
					if (getDataLen(msgFileds[i].getFieldValue(), charSet, dataUnit)> msgFileds[i]
							.getLength()) {
						throw new DataFormatException(" @" + msgFileds[i].getFieldTag() + " "
								+ msgFileds[i].getDescription() + "[" + msgFileds[i].getFieldValue() + "]"
								+ " Field value length exceed limit");
					}
				}

				if (msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_DOUBLE)) {
					try{
						double d = 0.0; 
						if(msgFileds[i].getFieldValue() == null || msgFileds[i].getFieldValue().equals("")){
							d = 0;
						}else{
							d = Double.parseDouble(msgFileds[i].getFieldValue());
						}
						NumberFormat nf = DecimalFormat.getNumberInstance();
						nf.setGroupingUsed(false);
						nf.setMaximumFractionDigits(msgFileds[i].getDlength());
						msgFileds[i].setFieldValue(nf.format(d));
						String[] dValue = msgFileds[i].getFieldValue().split("\\.");
						if (dValue.length > 1) {
							if (getDataLen(dValue[0], charSet, dataUnit) > msgFileds[i].getLength()
									|| getDataLen(dValue[1], charSet, dataUnit) > msgFileds[i].getDlength())
								throw new DataFormatException(" @" + msgFileds[i].getFieldTag()
										+ " " + msgFileds[i].getDescription() + "[" + msgFileds[i].getFieldValue() + "]"
										+ " Field value length exceed limit");
						} else {
							if (getDataLen(dValue[0], charSet, dataUnit) > msgFileds[i].getLength())
								throw new DataFormatException(" @" + msgFileds[i].getFieldTag()
										+ " " + msgFileds[i].getDescription() + "[" + msgFileds[i].getFieldValue() + "]"
										+ " Field value length exceed limit");
						}	
					}catch(NumberFormatException e){
						throw new DataFormatException(" @" + msgFileds[i].getFieldTag() + " "
								+ msgFileds[i].getDescription() + "[" + msgFileds[i].getFieldValue() + "]"
								+ " Field value not match double format");
					}			
				}

				if (msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_STRING)) {
					int realLenth=getDataLen(msgFileds[i].getFieldValue(), charSet, dataUnit);
					if (realLenth > msgFileds[i].getLength() ){ 
						if(msgFileds[i].isTrimIfExceed()){  //������TrimIfExceed
							if(MessageConstants.DATA_UNIT_STRING.equals(dataUnit)){	//�������ַ���
								msgFileds[i].setFieldValue( msgFileds[i].getFieldValue().substring(0,msgFileds[i].getLength()));
							}else{		//�������ֽڳ��ȣ��ضϿ��ܵ��½����Ľ�ȡһ����������һ���ַ���Ч						
								String tempCharset= charSet==null?Charset.defaultCharset().name(): charSet;
								String newStr= truncate(msgFileds[i].getFieldValue(), tempCharset, msgFileds[i].getLength());
								msgFileds[i].setFieldValue(newStr);
							}							
						}else{
							throw new DataFormatException(" @" + msgFileds[i].getFieldTag()
								+ " " + msgFileds[i].getDescription() + "[" + msgFileds[i].getFieldValue() + "]"
								+ " Field value length exceed limit");
						}
					}
					if(msgFileds[i].getIsRequire().equals("Y")&&msgFileds[i].getFieldValue().trim().equals(""))
						throw new DataFormatException(" @" + msgFileds[i].getFieldTag()
								+ " " + msgFileds[i].getDescription()
								+ " Field value can not be null");
				}
				
				if (msgFileds[i].getDataType().equals(MessageConstants.DATA_VAR_LL)||msgFileds[i].getDataType().equals(MessageConstants.DATA_VAR_LLL)) {
					if(getDataLen(msgFileds[i].getFieldValue(), charSet, dataUnit) > msgFileds[i].getLength())
						throw new DataFormatException(" @" + msgFileds[i].getFieldTag()
								+ " " + msgFileds[i].getDescription() + "[" + msgFileds[i].getFieldValue() + "]"
								+ " Field value length exceed limit");
					if(msgFileds[i].getIsRequire().equals("Y")&&msgFileds[i].getFieldValue().trim().equals(""))
						throw new DataFormatException(" @" + msgFileds[i].getFieldTag()
								+ " " + msgFileds[i].getDescription()
								+ " Field value can not be null");
				}
				if (msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_OBJECT)) {
					Tools.checkMessage(msgFileds[i].getObjectMessage(), charSet, dataUnit);
				}
				if(msgFileds[i].getDataType().equals(MessageConstants.DATA_TYPE_ARRAY)) {
					for(Message subMess : msgFileds[i].getFieldArrayValue()){
						Tools.checkMessage(subMess, charSet, dataUnit);
					}
				}
			}
		}catch(Exception e){
			ExceptionFactory.parse(e,"���ĸ�ʽУ��");
		}
		
	}
	
	/**
	 * <p>���ʱ�����ֶε�Ҫ����и�ʽ��</p>
	 * @param field
	 * @return
	 * @throws Exception 
	 * @throws NumberFormatException 
	 */
	public static String formatFixSize(Field field, String charSet, String dataUnit, String decimalPoint) throws OCIException {
		String sTemp = "";
		try{
			if(field.getDataType().equals(MessageConstants.DATA_TYPE_INT)){
				BigInteger bg;
				int integerDigits = field.getLength();
				if(field.getFieldValue() == null || field.getFieldValue().equals("")){
					bg = new BigInteger("0");
				}else{
					bg = new BigInteger(field.getFieldValue());
				}
				
				for (int j = 0; j < integerDigits; j++) {
					sTemp = "0" + sTemp;
				}
				DecimalFormat df = new DecimalFormat(sTemp);
				field.setParsedValue(df.format(bg));
				return df.format(bg);
				
			}else if(field.getDataType().equals(MessageConstants.DATA_TYPE_DOUBLE)){
				double d;
				
				int integerDigits = field.getLength();
				int fractionDigits =  field.getDlength();
				
				if(field.getFieldValue() == null || field.getFieldValue().equals("")){
					d = 0;
				}else{
					d = Double.parseDouble(field.getFieldValue());
				}	
				
				if (fractionDigits > 0) {
					sTemp += ".0";		
					for (int i = 0; i < fractionDigits - 1; i++) {
						sTemp += "0";
					}
				}
				for (int i = 0; i < integerDigits; i++) {
					sTemp = "0" + sTemp;
				}
				DecimalFormat df = new DecimalFormat(sTemp);
				field.setParsedValue(df.format(d));
				if(decimalPoint.equals(MessageConstants.DECIMAL_POINT_YES)){//��С����
					field.setParsedValue(df.format(d));
					return df.format(d);
				}else{		//����С����
					field.setParsedValue(df.format(d).replace(".", ""));
					return df.format(d).replace(".", "");
				}	
			}else if(field.getDataType().toLowerCase().equals(MessageConstants.DATA_TYPE_STRING)){
				String s = "";
				int integerDigits = field.getLength();
				if(field.getFieldValue() != null)
					s = field.getFieldValue();
				for (int j = 0; j < integerDigits; j++) {
					sTemp = " " + sTemp;
				}
				String returnStr = s + sTemp.substring(getDataLen(s, charSet, dataUnit));
				field.setParsedValue(returnStr);
				return returnStr;
				
			}else if(field.getDataType().toLowerCase().equals(MessageConstants.DATA_TYPE_BYTE)){
				byte[] b = new byte[field.getLength()];
				String defaultByteStr = "";
				if(field.getFieldValue().trim().equals("")){
					field.setFieldValue("0");
				}
				String[] byteInts = field.getFieldValue().split(",");
				for(int k =0; k < b.length; k++){
					b[k] = 0;
				}
				for(int k =0; k < byteInts.length; k++){
					b[k] = (byte) Integer.parseInt(byteInts[k]);
				}
				for(int k = 0; k < b.length; k++){
					defaultByteStr += "," + b[k];
				}
				field.setFieldValue(defaultByteStr.substring(1));
				field.setParsedValue(defaultByteStr.substring(1));
				return new String(b);
			}else if(field.getDataType().equals(MessageConstants.DATA_VAR_LL)){
				String s = field.getFieldValue();
				DecimalFormat df = new DecimalFormat("00");
				String returnStr = df.format(getDataLen(s, charSet, dataUnit)) + field.getFieldValue();
				field.setParsedValue(returnStr);
				return returnStr;
			}else if(field.getDataType().equals(MessageConstants.DATA_VAR_LLL)){
				String s = field.getFieldValue();
				DecimalFormat df = new DecimalFormat("000");
				String returnStr = df.format(getDataLen(s, charSet, dataUnit)) + field.getFieldValue();
				field.setParsedValue(returnStr);
				return returnStr;
			}else{
				return sTemp;
			}
		}catch(Exception e){
			ExceptionFactory.parse(e,"��ʽ���������  Field(" + field.getFieldTag() + ")");
		}
		return null;
	}
	
	/**
	 * <p>����ַ����ĳ��ȣ���������ַ��������Ļ����򳤶�Ϊ�ַ������ȣ�����Ϊ�ֽڵĳ���</p>
	 * @throws UnsupportedEncodingException 
	 */
	public static int getDataLen(String s, String charSet, String dataUnit) throws UnsupportedEncodingException{
		int length;
		if(charSet == null){
			length = s.length();
		}else if(dataUnit == null){
			length = s.getBytes(charSet).length;
		}else{
			length = dataUnit.equals(MessageConstants.DATA_UNIT_STRING)? 
					s.length(): s.getBytes(charSet).length;
		}
		return length;
	}

	/**
	 *  <p>��ȡ��ָ�������ֽ����鵽�µ����� </p>
	 * @param itBytes ��ȡ�ֽ�������ʼλ������
	 * @param beginIndex ��ȡ�ֽ��������λ������
	 * @param endIndex
	 * @return
	 */
	public static byte[] getCutBytes(byte[] itBytes, int beginIndex, int endIndex){
		byte[] tempBytes = new byte[endIndex - beginIndex + 1];
		for(int k = 0; k < tempBytes.length; k++){
			tempBytes[k] = itBytes[k + beginIndex];
		}
		return tempBytes;
	}
	

	/**
	 * �õ���ǰ��ʱ��*********************************** 
	 * ����ֵ: 1	:HHMMSS  2:HH:MM:SS		3 HHmmssSSS		4 HH:mm:ss:SSS
	 * 
	 * @return String
	 */
	public static String getTime(int i) {
		String prev = new java.sql.Time(System.currentTimeMillis()).toString()
				.trim();
		if (i == 1)
			prev = prev.substring(0, 2) + prev.substring(3, 5)
					+ prev.substring(6, 8);
		if (i == 2)
			prev = prev.substring(0, 2) + ":" + prev.substring(3, 5) + ":"
					+ prev.substring(6, 8);
		if(i == 3){
			SimpleDateFormat sdf = new SimpleDateFormat("HHmmssSSS");
			prev = sdf.format(new Date());
		}
		if(i == 4){
			SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss:SSS");
			prev = sdf.format(new Date());
		}
		return prev;
	}

	public static String replaceAll(String s1, String s2, String s3) {
		while (s1.indexOf(s2) > 0) {

			s1 = s1.substring(0, s1.indexOf(s2)) + s3
					+ s1.substring(s1.indexOf(s2) + s2.length());
		}
		return s1;
	}

	public static double getBaseRate(Connection connection,
			String sBusinessType, String sBusinessSubType, int iLoanTerm,
			String sEffDate) throws SQLException {
		// �������
		String sSql = "";// Sql���
		String sAdjustDate = "";// ��������
		double dMinLoanTerm = 0.0;// ��С������������
		double dMonthRate = 0.0;// ������
		ResultSet rs = null;

		try {
			// ��ȡ���ĵ�������
			sSql = " select max(AdjustDate) as AdjustDate "
					+ " from LOANRATE_LIST " + " where BusinessType like '%"
					+ sBusinessType + "%' " + " and BusinessSubType = '"
					+ sBusinessSubType + "' " + " and Term >= " + iLoanTerm
					+ " " + " and AdjustDate <= '" + sEffDate + "'";
			rs = connection.createStatement().executeQuery(sSql);
			if (rs.next())
				sAdjustDate = rs.getString("AdjustDate");
			rs.getStatement().close();
			if (sAdjustDate == null)
				sAdjustDate = "";

			// ��ȡ��С������
			sSql = " select min(Term) as Term " + " from LOANRATE_LIST "
					+ " where BusinessType like '%" + sBusinessType + "%' "
					+ " and BusinessSubType = '" + sBusinessSubType + "' "
					+ " and Term >= " + iLoanTerm + " " + " and AdjustDate = '"
					+ sAdjustDate + "' ";
			rs = connection.createStatement().executeQuery(sSql);
			if (rs.next())
				dMinLoanTerm = rs.getDouble("Term");
			rs.getStatement().close();

			// ��ȡ��Ч�Ļ�׼����
			sSql = " select nvl(MonthRate,0) as MonthRate "
					+ " from LOANRATE_LIST " + " where BusinessType like '%"
					+ sBusinessType + "%' " + " and BusinessSubType = '"
					+ sBusinessSubType + "' " + " and Term = " + dMinLoanTerm
					+ " " + " and AdjustDate = '" + sAdjustDate + "' ";
			rs = connection.createStatement().executeQuery(sSql);
			if (rs.next())
				dMonthRate = rs.getDouble("MonthRate");
			rs.getStatement().close();
		} catch (Exception exception) {
			throw new SQLException("��ȡ��׼���ʴ���" + exception.toString());
		}
		return dMonthRate;
	}

	static public String getRelativeMonth(String sDate, int i)
			throws ParseException {
		if (i == 0)
			return sDate;
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
		cal.setTime(formatter.parse(sDate));
		cal.add(Calendar.MONTH, i);
		return formatter.format(cal.getTime());
	}

	/**
	 * �õ���ǰ������*********************************** ����ֵ: 
	 * 
	 * type=1--YYYYMMDD type=2--YYYY/MM/DD type=3--YYMMDD type=4--MMDD
	 * 
	 * @param type
	 *            int
	 * @return String
	 */
	public static String getToday(int type) {
		String prev = new java.sql.Date(System.currentTimeMillis()).toString()
				.trim();
		prev = prev.substring(0, 4) + "/" + prev.substring(5, 7) + "/"
				+ prev.substring(8, 10);
		return getToday(type, prev);
	}

	public static String getToday(int type, String date) {
		if (type == 1) {
			return date.substring(0, 4) + date.substring(5, 7)
					+ date.substring(8, 10);
		} else if (type == 2) {
			return date;
		} else if (type == 3) {
			return date.substring(2, 4) + date.substring(5, 7)
					+ date.substring(8, 10);
		} else if (type == 4) {
			return date.substring(5, 7) + date.substring(8, 10);
		} else {
			return date.substring(0, 4) + date.substring(5, 7)
					+ date.substring(8, 10);
		}
	}



	// �ַ�������
	public static String StringReverse(String string) {
		byte[] sReturn = new byte[string.length()];
		byte[] bytearray = string.getBytes();

		for (int i = bytearray.length - 1; i >= 0; i--)
			sReturn[bytearray.length - i - 1] = bytearray[i];

		return new String(sReturn);
	}

	// ������ת����ʮ������
	public static String BitToHex(String value) {
		// ���Ϊ4��������
		String STRING_VALUE = value;
		String sReturn = "";
		while (STRING_VALUE.length() % 4 != 0) {
			STRING_VALUE = "0" + STRING_VALUE;
		}
		/*
		 * 4λ4λת��
		 */
		byte[] BYTE_VALUE_ARRAY = STRING_VALUE.getBytes();
		for (int i = 0; i < STRING_VALUE.length(); i = i + 4) {
			String Tmp = new String(BYTE_VALUE_ARRAY, i, 4);
			sReturn += DToHex(BitToD(Tmp));
		}
		return sReturn;
	}

	// ʮ����ת��ʮ������
	public static String DToHex(int value) {
		if (value < 10)
			return "" + value;
		else {
			String string = "ABCDEF";
			return string.substring(value - 10, value - 9);
		}
	}

	// ������ת��ʮ����
	public static int BitToD(String value) {
		int sReturn = 0;
		for (int i = value.length() - 1; i >= 0; i--) {

			if (value.substring(i, i + 1).equals("1"))
				sReturn += (int) Math.pow(2, value.length() - i - 1);
		}

		return sReturn;
	}

	/*
	 * ��ú͸�������sDate���Days�������
	 */
	public static String diffDay(String sDate, int Days) throws Exception {
		if (Days == 0)
			return sDate;
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd");
		cal.setTime(formatter.parse(sDate));
		cal.add(Calendar.DATE, Days);
		return formatter.format(cal.getTime());
	}

	public static boolean monthEnd(String date) {
		int i = Integer.parseInt(date.substring(0, 4));
		int j = Integer.parseInt(date.substring(5, 7));
		int k = Integer.parseInt(date.substring(8, 10));
		if (k == 31)
			return true;
		if (k == 30 && (j == 4 || j == 6 || j == 9 || j == 11))
			return true;
		if (k == 29 && j == 2)
			return true;
		if (k == 28 && j == 2 && i % 4 != 0)
			return true;
		return false;
	}
	
	/**
	 * ��XML�ļ��еı�ǩ������ͳһת�ɴ�д��Сд
	 * @param element	Ҫת����JDOM��XML�ڵ�
	 * @param toLower   תСдtrue��ת��дfalse
	 */
	private static void changeXmlTagCase(Element element ,boolean toLower){
		element.setName(element.getName().toLowerCase());
		for( Object obj:element.getAttributes()){
			if (obj instanceof Attribute) {
				Attribute attr = (Attribute) obj;
				if (toLower){
					attr.setName(attr.getName().toLowerCase());
				} else{
					attr.setName(attr.getName().toUpperCase());
				}
			}			
		}
		for(Object obj:element.getChildren()){
			if (obj instanceof Element) {
				Element child = (Element) obj;
				changeXmlTagCase(child,toLower);
			}
		}		
	}	
	public static void xmlTagToLower(Element element){
		changeXmlTagCase(element, true);
	}	
	public static void xmlTagToUpper(Element element){
		changeXmlTagCase(element, false);
	}	
	/**
	 * @param param	Map���keyΪcategory��valueΪһ��map������в����ĵļ�ֵ��
	 * @param sql Ҫ�滻��sql���
	 * @return	�滻���sql���
	 */
	public static String replaceSqlParam(Map<String,Map<String,String>> param,String sql){
		String result= sql;
		Iterator<Entry<String,Map<String,String>>> iterator =param.entrySet().iterator();
		while(iterator.hasNext()){		//ѭ��ÿ����������
			Entry<String, Map<String,String>> entry= iterator.next();
			String category= entry.getKey();//.toLowerCase();			//��������
			
			Map<String,String> fieldsMap=entry.getValue();		//ԭ����map
			if(!(fieldsMap instanceof SortedMap)){				//ԭ����mapû�����������һ��
				Map<String,String> sortedMap=new TreeMap<String, String>(Collections.reverseOrder());	//������
				sortedMap.putAll(fieldsMap);			//����ԭ���ݲ�����
				fieldsMap=sortedMap;
			}					
			Iterator<Entry<String, String>> fieldValues= fieldsMap.entrySet().iterator();	
			while(fieldValues.hasNext()){		//���������Ź���Ĳ���
				Entry<String, String> entry2= fieldValues.next();		
				String origParamName= entry2.getKey();//.toLowerCase();	//����������
				String value= entry2.getValue();						//������ֵ
				String paramName= new StringBuilder("#").append(category).append(".")
														.append(origParamName).toString();
				if (result.indexOf(paramName)>-1){	//���������������滻��ֵ
					result=result.replaceAll(paramName, value);
				}
			}
		}
		return result;
	}	
	
}