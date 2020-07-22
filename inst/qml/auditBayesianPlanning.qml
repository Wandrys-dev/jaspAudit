
// Copyright (C) 2013-2018 University of Amsterdam
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.\
//

// When making changes to this file always mention @koenderks as a
// reviewer in the Pull Request

import QtQuick 					2.8
import QtQuick.Layouts 	1.3
import JASP.Controls 		1.0
import JASP.Widgets 		1.0

Form 
{
	usesJaspResults: 									true
	columns:													1

	// Extra options
	CheckBox 
	{ 
		name: 													"workflow"
		checked: 												false
		visible: 												false
	}

	CheckBox 
	{ 
		name: 													"stratificationTopAndBottom"
		checked: 												false
		visible: 												false
	}

	GridLayout
	{
		columns: 												3

		GroupBox 
		{
			id: 													auditGoals
			name: 												"auditGoals"
			title: 												"Sampling Objectives"

			CheckBox
			{
				id: 												performanceMateriality
				text: 											"Test against a performance materiality"
				name: 											"performanceMateriality"

				RadioButtonGroup
				{
					id: 											materiality
					name: 										"materiality"

					RowLayout
					{
						visible: 								performanceMateriality.checked
						
						RadioButton
						{
							id: 									materialityAbsolute
							name: 								"materialityAbsolute"
							text: 								qsTr("Absolute")
							checked: 							true
							childrenOnSameRow: 		true

							DoubleField
							{
								id: 								materialityValue
								visible: 						materialityAbsolute.checked
								name: 							"materialityValue"
								defaultValue: 			0
								min: 								0
								fieldWidth: 				90
								decimals: 					2
								label: 							euroValuta.checked ? "€" : (dollarValuta.checked ? "$" : otherValutaName.value)
							}
						}
					}

					RowLayout
					{
						visible: 								performanceMateriality.checked
						
						RadioButton
						{
							id: 									materialityRelative
							name: 								"materialityRelative"
							text: 								qsTr("Relative")
							childrenOnSameRow: 		true

							PercentField
							{
								id: 								materialityPercentage
								visible: 						materialityRelative.checked
								decimals: 					2
								defaultValue: 			0
								name: 							"materialityPercentage"
								fieldWidth: 				40
							}
						}
					}
				}
			}

			CheckBox
			{
				id: 												reduceUncertainty
				text: 											"Obtain a minimum precision"
				name: 											"reduceUncertainty"
			
				PercentField
				{
					id: 											maximumUncertaintyPercentage
					name: 										"maximumUncertaintyPercentage"
					decimals: 								2
					defaultValue: 						2
					label: 										"Relative"
					visible: 									reduceUncertainty.checked
				}
			}
		}

		GroupBox
		{
			title: 												qsTr("Population")

			IntegerField
			{
				id: 												populationSize
				name: 											"populationSize"
				text: 											qsTr("Size")
				fieldWidth: 								100
				defaultValue: 							0
				min: 												0
			}

			DoubleField
			{
				id: 												populationValue
				name: 											"populationValue"
				text: 											qsTr("Value")
				defaultValue: 							0
				enabled: 										materialityAbsolute.checked
				fieldWidth: 								100
				min: 												0
				decimals: 									2
			}
		}

		GroupBox
		{
			id: 													auditRisk
			title: 												qsTr("Audit Risk")

			PercentField
			{
				name: 											"confidence"
				label: 											qsTr("Confidence")
				decimals: 									2
				defaultValue: 							95
			}
		}
	}

	Section 
	{
		title: 													qsTr("A.     Prior Information")
		columns: 												3
		enabled:												(performanceMateriality.checked || reduceUncertainty.checked)

		RadioButtonGroup
		{
			id: 													ir
			title: 												qsTr("Inherent Risk")
			name: 												"IR"

			RadioButton 
			{ 
				text: 											qsTr("High")
				name: 											"High"
				checked: 										true	
			}

			RadioButton 
			{ 
				text: 											qsTr("Medium")
				name: 											"Medium"
			}

			RadioButton 
			{ 
				text: 											qsTr("Low")
				name: 											"Low"
			}
			
			RadioButton
			{
				id: 												irCustom
				text:	 											qsTr("Custom")
				name: 											"Custom"
				childrenOnSameRow: 					true

				PercentField
				{
					name: 										"irCustom"
					visible: 									irCustom.checked
					decimals: 								2
					defaultValue: 						100
					min: 											25
				}
			}
		}

		RadioButtonGroup
		{
			id: 													cr
			title: 												qsTr("Control Risk")
			name: 												"CR"

			RadioButton 
			{ 
				text: 											qsTr("High")
				name: 											"High"
				checked: 										true	
			}

			RadioButton 
			{ 
				text: 											qsTr("Medium")
				name: 											"Medium"
			}

			RadioButton 
			{ 
				text: 											qsTr("Low")
				name: 											"Low"
			}

			RadioButton
			{
				id: 												crCustom
				text:	 											qsTr("Custom")
				name: 											"Custom"
				childrenOnSameRow: 					true

				PercentField
				{
					name: 										"crCustom"
					visible: 									crCustom.checked
					decimals: 								2
					defaultValue: 						100
					min:											25
				}
			}
		}

		RadioButtonGroup
		{
			id: 													expectedErrors
			name: 												"expectedErrors"
			title: 												qsTr("Expected Errors")

			RowLayout
			{
				RadioButton 
				{ 
					id: 											expectedAbsolute
					name: 										"expectedAbsolute"
					text: 										qsTr("Absolute")
				}

				DoubleField
				{
					name: 										"expectedNumber"
					enabled: 									expectedAbsolute.checked
					defaultValue: 						0
					min: 											0
					max: 											1e10
					decimals: 								2
					visible: 									expectedAbsolute.checked
					fieldWidth: 							60
					label: 										performanceMateriality.checked && materialityAbsolute.checked ? "$" : ""
				}
			}

			RowLayout
			{
				RadioButton 
				{ 
					id: 											expectedRelative
					name: 										"expectedRelative"
					text: 										qsTr("Relative")
					checked: 									true
				}

				PercentField
				{
					name: 										"expectedPercentage"
					enabled: 									expectedRelative.checked
					decimals: 								2
					defaultValue: 						0
					visible: 									expectedRelative.checked
					fieldWidth: 							40
				}
			}
		}
	}

	Section
	{
		text: 													qsTr("B.     Advanced Options")
		columns:												4
		enabled:												(performanceMateriality.checked || reduceUncertainty.checked)

		RadioButtonGroup
		{
			id: 													planningModel
			title: 												qsTr("Probability Distribution")
			name: 												"planningModel"

			RadioButton
			{
				id: 												beta
				text: 											qsTr("Beta")
				name: 											"binomial"
				checked: 										true
			}

			RadioButton
			{
				id: 												gamma
				text: 											qsTr("Gamma")
				name: 											"Poisson"
			}

			RadioButton
			{
				id: 												betaBinomial
				text: 											qsTr("Beta-binomial")
				name: 											"hypergeometric"
			}
		}

		GroupBox
		{
			title: 												qsTr("Calculation Settings")

			IntegerField 
			{
				name: 											"sampleSizeIncrease"
				text: 											qsTr("Step size")
				min: 												1
				max:												20
				defaultValue: 							1
			}
		}

		RadioButtonGroup
		{
			id: 													valuta
			title: 												qsTr("Currency")
			name: 												"valuta"
			enabled:											materialityAbsolute.checked

			RadioButton 	
			{ 
				id: 												euroValuta
				text: 											qsTr("Euro (€)")
				name: 											"euroValuta"
				checked: 										true
			}

			RadioButton 	
			{ 
				id: 												dollarValuta	
				text: 											qsTr("Dollar ($)")
				name: 											"dollarValuta"
			}

			RowLayout
			{
				RadioButton	
				{ 
					id: 											otherValuta
					text:											qsTr("Other")
					name: 										"otherValuta"	
				}

				TextField
				{
					id: 											otherValutaName
					name: 										"otherValutaName"
					fieldWidth: 							100
					enabled: 									otherValuta.checked
					visible: 									otherValuta.checked
				}
			}
		}

		GroupBox
		{
			title: 												qsTr("Explanatory Text")
			columns: 2

			CheckBox
			{
				id: 												explanatoryText
				text: 											qsTr("Enable")
				name: 											"explanatoryText"
				checked: 										true
			}

			HelpButton
			{
				helpPage:										"Audit/explanatoryText"
				toolTip: 										qsTr("Show explanatory text at each step of the analysis")
			}
		}	
	}

	Section
	{
		title: 													qsTr("C.     Tables and Plots")
		columns:												2
		enabled:												(performanceMateriality.checked || reduceUncertainty.checked)

		ColumnLayout
		{
			GroupBox
			{
				title: 											qsTr("Statistics")

				CheckBox
				{
					text: 										qsTr("Expected evidence ratio")
					name: 										"expectedEvidenceRatio"
					enabled:									performanceMateriality.checked
				}

				CheckBox
				{
					text: 										qsTr("Expected Bayes factor (BF\u208B\u208A)")
					name: 										"expectedBayesFactor"
					enabled:									performanceMateriality.checked
				}
			}

			GroupBox
			{
				title: 											qsTr("Tables")

				CheckBox
				{
					text: 										qsTr("Implicit sample")
					name: 										"implicitSampleTable"
				}

				CheckBox
				{
					text: 										qsTr("Prior and expected posterior descriptives")
					name: 										"priorStatistics"
				}
			}
		}

		GroupBox
		{
			title: 												qsTr("Plots")

			CheckBox
			{
				text: 											qsTr("Sample size comparison")
				name: 											"decisionPlot"
			}

			CheckBox
			{
				text: 											qsTr("Implied prior from risk assessments")
				name: 											"priorPlot"
				childrenOnSameRow: 					false

				PercentField
				{
					text: 										qsTr("x-axis limit")
					name: 										"priorPlotLimit"
					defaultValue: 						20
				}

				CheckBox
				{
					text: 										qsTr("Expected posterior")
					name: 										"priorPlotExpectedPosterior"
				}

				CheckBox
				{
					text: 										qsTr("Additional info")
					name: 										"priorPlotAdditionalInfo"
					checked: 									true

					RadioButtonGroup 
					{
						title: 									qsTr("Shade")
						name: 									"shadePrior"

						RadioButton
						{
							text: 								qsTr("Credible region")
							name: 								"shadePriorCredibleRegion"
							checked: 							true
						}

						RadioButton
						{
							text: 								qsTr("Support regions")
							name: 								"shadePriorHypotheses"
							enabled:							performanceMateriality.checked
						}

						RadioButton
						{
							text: 								qsTr("None")
							name: 								"shadePriorNone"
						}
					}
				}
			}
		}
	}

	Item
	{
		Layout.preferredHeight: 				downloadReportPlanning.height
		Layout.fillWidth: 							true

		Button
		{
			id: 													downloadReportPlanning
			enabled: 											materialityRelative.checked ? (populationSize.value != 0 && materialityPercentage.value != 0) : (populationSize.value != 0 && materialityValue.value != 0 && populationValue.value != 0)
			anchors.right: 								parent.right
			anchors.bottom: 							parent.bottom
			text: 												qsTr("<b>Download Report</b>")
			onClicked: 										form.exportResults()
		}
	}
}
