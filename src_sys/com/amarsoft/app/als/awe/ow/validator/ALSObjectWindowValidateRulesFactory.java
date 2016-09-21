package com.amarsoft.app.als.awe.ow.validator;

import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.log.Log;
import com.amarsoft.awe.dw.ASColumn;
import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.datamodel.CatalogModel;
import com.amarsoft.awe.dw.datamodel.ColValidateModel;
import com.amarsoft.awe.dw.datamodel.CommonValidateModel;
import com.amarsoft.awe.dw.datamodel.ExpressionValidation;
import com.amarsoft.awe.dw.datamodel.LibraryModel;
import com.amarsoft.awe.dw.ui.datamodel.MDataBuilder;
import com.amarsoft.awe.dw.ui.validator.IValidateRulesFactory;
import com.amarsoft.awe.dw.ui.validator.SortBySortNo;
import com.amarsoft.awe.dw.ui.validator.ValidateRule;
import com.amarsoft.dict.als.cache.AWEDataWindowCache;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;

public class ALSObjectWindowValidateRulesFactory implements IValidateRulesFactory {
	private int paramLength = 10;
	private ASDataObject asObj;

	public ALSObjectWindowValidateRulesFactory(ASDataObject asObj) {
		this.asObj = asObj;
	}

	private String getReplacedStr(String str, String title, String[] arr) {
		if (str == null)
			return "";
		str = str.replaceAll("\\{TITLE\\}", title);
		if (arr == null)
			return str;
		for (int i = 1; i <= this.paramLength; ++i) {
			if (arr[(i - 1)] != null) {
				str = str.replaceAll("\\{PARAM" + i + "\\}", arr[(i - 1)]);
			}
		}
		return str;
	}

	public Vector getValidateRules() throws Exception {
		Vector vResult = new Vector();

		vResult = doRequired(vResult);

		vResult = doElseRegular(vResult);

		ExpressionValidation.doExpressions(this.asObj.getDwcontext(), vResult);
		vResult.addAll(asObj.validateRules);
		Collections.sort(vResult, new SortBySortNo());
		return vResult;
	}

	private Hashtable<String, ArrayList<ColValidateModel>> groupColValidateModel(
			CatalogModel catalog) {
		Hashtable result = new Hashtable();
		ArrayList<ColValidateModel> list = catalog.getColValidateList();
		if (list != null) {
			for (ColValidateModel c : list) {
				if (!(result.containsKey(c.getColName()))) {
					result.put(c.getColName(), new ArrayList());
				}
				ArrayList sublist = (ArrayList) result.get(c.getColName());
				sublist.add(c);
			}
		}
		return result;
	}

	private CommonValidateModel getCommonValidateModel(
			ArrayList<CommonValidateModel> commonValidateList,
			ColValidateModel curcvm) {
		if (commonValidateList == null)
			return null;
		for (CommonValidateModel cvm : commonValidateList) {
			if (cvm.getValidatorname().equals(curcvm.getValidatorName()))
				return cvm;
		}
		return null;
	}

	private Vector doElseRegular(Vector result) throws Exception {
		String doNo = this.asObj.getDONO();
		CatalogModel catalog = AWEDataWindowCache.getInstance()
				.getCatalogModel(doNo);
		if (catalog == null) {
			if ((StringX.isEmpty(doNo))
					|| ((!(doNo.startsWith("jbo."))) && (!(doNo
							.equalsIgnoreCase("JSON"))))) {
				ARE.getLog()
						.warn("catalogTable找不到dono=" + this.asObj.getDONO());
			}
			return result;
		}
		//ArrayList<LibraryModel> libraryList = catalog.getLibraryList();
		ArrayList commonValidateList = AWEDataWindowCache.getInstance()
				.getCommonValidateList();
		Hashtable colvalidates = groupColValidateModel(catalog);
		if (this.asObj != null) {
			for (int i = 0; i < this.asObj.Columns.size(); ++i) {
				ASColumn lm = (ASColumn) this.asObj.Columns.get(i);
				if ("1".equals(lm.getAttribute("COLVISIBLE"))) {
					ArrayList<ColValidateModel> cvmlist = (ArrayList) colvalidates.get(lm.getAttribute("COLNAME"));
					if (cvmlist != null) {
						for (ColValidateModel cvm : cvmlist)
							if (!("Expression".equals(cvm.getValidatorName()))) {
								ValidateRule rule = null;
								CommonValidateModel commonvalidate = getCommonValidateModel(
										commonValidateList, cvm);
								if (commonvalidate == null)
									break;
								String[] params = { cvm.getParam1(),
										cvm.getParam2(), cvm.getParam3(),
										cvm.getParam4(), cvm.getParam5(),
										cvm.getParam6(), cvm.getParam7(),
										cvm.getParam8(), cvm.getParam9(),
										cvm.getParam10() };

								rule = new ValidateRule();
								rule.setName(cvm.getValidatorName() + "_"
										+ cvm.getColName().toUpperCase());
								rule.setType(commonvalidate.getValidatortype());
								rule.setErrmsg(getReplacedStr(commonvalidate
										.getErrmsg(), MDataBuilder
										.getColHeader(lm.getAttribute("COLHEADER"), lm
												.getAttribute("COLTABLENAME"), lm
												.getAttribute("COLNAME").toUpperCase(),
												this.asObj), params));
								rule.setControlto(lm.getAttribute("COLNAME").toUpperCase());
								rule.setRegular(getReplacedStr(
										commonvalidate.getRegular(), "", params));
								String sFunction = getReplacedStr(
										commonvalidate.getCusfunction(), "",
										params);
								rule.setFunction(sFunction);
								rule.setParams(params);
								rule.setCompareto(getReplacedStr(
										commonvalidate.getCompareto(), "",
										params));
								rule.setMin(getReplacedStr(
										commonvalidate.getMinvalue(), "",
										params));
								rule.setMax(getReplacedStr(
										commonvalidate.getMaxvalue(), "",
										params));
								rule.setSortno(lm.getAttribute("SORTNO"));
								rule.setUseStatus(cvm.getUseStatus());
								result.add(rule);
							}
					}
				}
			}
		}
		return result;
	}

	private Vector doRequired(Vector result) throws Exception {
		List<CommonValidateModel> commonValidateList = AWEDataWindowCache.getInstance()
				.getCommonValidateList();
		if (commonValidateList == null)
			return result;
		CommonValidateModel cm = null;
		for (CommonValidateModel m : commonValidateList) {
			if (m.getValidatorname().equals("Require")) {
				cm = m;
				break;
			}
		}
		if (cm == null)
			return result;

		if (this.asObj.Columns == null)
			return result;
		for (int i = 0; i < this.asObj.Columns.size(); ++i) {
			ASColumn column = (ASColumn) this.asObj.Columns.get(i);

			if ((column.getAttribute("COLREQUIRED") != null)
					&& (column.getAttribute("COLREQUIRED").equals("1"))) {
				ValidateRule rule = new ValidateRule();
				rule.setName("Require_"
						+ column.getAttribute("COLNAME").toUpperCase());
				rule.setType("Require");
				rule.setErrmsg("请输入"
						+ this.asObj.getColumnAttribute(
								column.getAttribute("COLNAME").toUpperCase(),
								"COLHEADER"));
				rule.setControlto(column.getAttribute("COLNAME").toUpperCase());
				rule.setSortno(column.getAttribute("SORTNO"));
				result.add(rule);
			}

			if ("Date".equalsIgnoreCase(column.getAttribute("COLEDITSTYLE"))) {
				ValidateRule rule = new ValidateRule();
				rule.setName("Date_"
						+ column.getAttribute("COLNAME").toUpperCase());
				rule.setType("Date");
				rule.setErrmsg("请输入正确的日期格式：yyyy/mm/dd");
				rule.setControlto(column.getAttribute("COLNAME").toUpperCase());
				rule.setSortno(column.getAttribute("SORTNO"));
				result.add(rule);
			}

			if (column.getAttribute("COLLIMIT") != null) {
				String sColLimit = column.getAttribute("COLLIMIT").trim();
				if ((!(sColLimit.equals(""))) && (!(sColLimit.equals("0")))) {
					ValidateRule rule = new ValidateRule();
					rule.setName("COLLIMIT_"
							+ column.getAttribute("COLNAME").toUpperCase());
					rule.setType("Length");
					rule.setFunction(sColLimit);

					rule.setErrmsg("您输入的" + column.getAttribute("COLHEADER")
							+ "超长(字节数" + sColLimit + "位)");
					rule.setControlto(column.getAttribute("COLNAME")
							.toUpperCase());
					rule.setSortno(column.getAttribute("SORTNO"));
					result.add(rule);
				}
			}
		}
		return result;
	}
}