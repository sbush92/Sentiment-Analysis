#include <iostream>
#include <sstream>
#include <fstream>
#include <stdio.h>
#include <map>
#include <string>
#include "vector"
#include <algorithm>
#include <chrono>

using namespace std;
// Comparator function to sort pairs
// according to second value
bool cmp(pair<string, float>& a,
	pair<string, float>& b)
{
	return a.second < b.second;
}


int main()
{
	string lineInput;
	string delimiter = " ";
	size_t pos = 0;
	string token;

	map <string, map<string, float>> all_com;
	map <string, float> countAll;

	vector<float> occurrenceCount;
	map <string, float> p_t;
	map <string, map<string, float>> p_t_com;
	map <string, map<string, float>> pmi;
	vector<pair<string, float>> semanticOrientation;
	int count = 0;
	float n_docs = 0;
	//getline(cin, lineInput);


	vector<string> positiveVocab;
	vector<string> negativeVocab;

	// Read in Postive Words List
	string positiveText;
	ifstream PositiveFile("positive-words.txt");
	if (PositiveFile.fail()) {
		cout << "positive-words.txt does not exist" << endl;
	}
	else {
		//cout << "File Found" << endl;
		if (PositiveFile.is_open()) {
			//cout << "file is open" << endl;
			while (getline(PositiveFile, positiveText)) {
				positiveVocab.push_back(positiveText);
			}
		}

	}
	PositiveFile.close();

	// Read in Negative Words List
	string negativeText;
	ifstream NegativeFile("negative-words.txt");
	if (NegativeFile.fail()) {
		cout << "negative-words.txt does not exist" << endl;
	}
	else {
		//cout << "File Found" << endl;
		if (NegativeFile.is_open()) {
			//cout << "file is open" << endl;
			while (getline(NegativeFile, negativeText)) {
				negativeVocab.push_back(negativeText);
			}
		}
	}
	NegativeFile.close();



	// CODE FOR TESTING
	string myText;
		while (getline(cin, lineInput)) {
			auto start = chrono::high_resolution_clock::now();
			map <string, float> countAll;
			map <string, map<string, float>> com;
			n_docs += 1;
			// Terms need to be recreated every time a tweet is read
			vector<string> terms;
			// Put input into an array
			while ((pos = lineInput.find(delimiter)) != std::string::npos) {
		
				// vector of terms

				token = lineInput.substr(0, pos);
				terms.push_back(token);

				//cout << token << endl;
				lineInput.erase(0, pos + delimiter.length());

				// Push into count all and count
				if (countAll.find(token) == countAll.end()) {

					countAll[token] = 1;
				}
				else {
					countAll[token] += 1;
				};
			}
			//// last one in
			//terms.push_back(lineInput);
			//// Push last one into count all and count
			//if (countAll.find(lineInput) == countAll.end()) {

			//	countAll[lineInput] = 1;
			//}
			//else {
			//	countAll[lineInput] += 1;
			//};

			// Set Ndocs
			n_docs = stoi(lineInput);

			// Sort Common Terms
			std::sort(terms.begin(), terms.end());

			// Build co - occurrence matrix 
			for (unsigned int i = 0; i < terms.size(); i++) {
				for (unsigned int j = 0; j < terms.size(); j++) {
					string w1, w2;
					w1 = terms[i];
					w2 = terms[j];
					if (w1 != w2) {

						map <string, float> w2Temp;
						
						all_com[w1][w2] += 1;
						com[w1][w2] = all_com[w1][w2];
					}
				}
			}

			for (auto term1 : countAll) {
				p_t[term1.first] = term1.second / n_docs;
				for (auto term2 : com[term1.first]) {
					p_t_com[term1.first][term2.first] = com[term1.first][term2.first] / n_docs;
				}
			}
		

			for (auto term1 : p_t) {
				for (auto term2 : com[term1.first]) {
					try {
						float denom;
						denom = p_t[term1.first] * p_t[term2.first];
						pmi[term1.first][term2.first] = log2(p_t_com[term1.first][term2.first] / denom);
					}
					catch (...) {
					//do nothing
					}
				}
			}


			std::map<string, float>::iterator it;
			////Remove positive and negative terms from p_t
			//for (auto term : positiveVocab) {

			//	countAll.erase(term);

			//}
			//for (auto term : negativeVocab) {
			//	countAll.erase(term);

			//}

			double tweetScore = 0;
			for (auto term : countAll) {
				float positiveAssoc = 0;
				float negativeAssoc = 0;
				bool skip = false;

				//Positive
				for (vector<string>::iterator it = positiveVocab.begin(); it != positiveVocab.end(); ++it) {




					if (pmi[term.first].count(*it) != 0) {
						positiveAssoc += pmi[term.first][*it];
					}




				}
				//Negative
				for (vector<string>::iterator it = negativeVocab.begin(); it != negativeVocab.end(); ++it) {

					if (pmi[term.first].count(*it) != 0) {
						negativeAssoc += pmi[term.first][*it];
					}



				}


		/*		auto temp = find_if(semanticOrientation.begin(), semanticOrientation.end(), [&term](std::pair<string, float> const& ref) {
					return ref.first == term.first;
					});*/


				bool duplicate = false;

			
				for (int i = 0; i < semanticOrientation.size(); ++i) {
					if (semanticOrientation.at(i).first == term.first) {
						semanticOrientation.at(i).second = semanticOrientation.at(i).second + positiveAssoc - negativeAssoc;
						tweetScore = tweetScore + positiveAssoc - negativeAssoc;
						duplicate = true;
					}
				}

				if (duplicate == false) {
					semanticOrientation.push_back(make_pair(term.first, (positiveAssoc - negativeAssoc)));
					tweetScore = tweetScore + positiveAssoc - negativeAssoc;
				}
		
		
		


			}

		
		
			//// If multiple consididate and update value
			//for (auto i = semanticOrientation.begin();i < semanticOrientation.end(); i++) {
			//	for (auto j = semanticOrientation.begin();j < semanticOrientation.end(); i++) {

			//		std::cout << i->first << endl;

			//	}
			//}


			// sort map
			std::sort(semanticOrientation.begin(), semanticOrientation.end(), cmp);

			std::cout << "Top Positive" << endl;


			for (auto i = semanticOrientation.rbegin(); i < semanticOrientation.rbegin() + 3; i++) {
				std::cout << i->first
					<< " = "
					<< i->second
					<< endl;
			}

			//print in reverse order from worst to best.
			std::cout << "Top Negative" << endl;
			for (auto i = semanticOrientation.begin();i < semanticOrientation.begin() + 3; i++) {
				std::cout << i->first
					<< " = "
					<< i->second
					<< endl;
			}
			std::cout << "Tweet Score: " << tweetScore << endl;
			auto stop = chrono::high_resolution_clock::now();
			auto duration = chrono::duration_cast<chrono::microseconds>(stop - start);
			std::cout << "Time Elapsed: " << duration.count() << " Microseconds" << endl;
			std::cout << endl;


		


			if (lineInput.empty()) {

				std::cout << "EOF";
				std::cout.flush();
			}
		}


	return 0;
}

// Sort terms
//sort(terms.begin(), terms.end());