#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <iostream>
#include <sstream>
#include <fstream>
#include <stdio.h>
#include <map>
#include "vector"
#include <algorithm>
#include <chrono>
using namespace std;
// Maybe implement later
//__global__ void sentimentAnalysis(string* positiveVocab, string* negativeVocab) {
//	int i = threadIdx.x;
//	
//	float positiveAssoc = 0;
//	float negativeAssoc = 0;
//	for (vector<string>::iterator it = positiveVocab.begin(); it != positiveVocab.end(); ++it) {
//		//Positive
//		countPositive();
//	
//	}
//	for (vector<string>::iterator it = negativeVocab.begin(); it != negativeVocab.end(); ++it) {
//		//Negative
//		countNegative();
//
//	}
//	semanticOrientation[item.first] = positiveAssoc - negativeAssoc;
//
//
//}

//__global__ void countPositive(string* positiveVocab) {
//	int i = threadIdx.x;
//	/*	if (*it == item.first) {
//			negativeAssoc += pmi[item.first].begin()->second;
//		}*/
//
//}
//
//__global__ void countNegative(string* negativeVocab) {
//	int i = threadIdx.x;
//	//if (*it == item.first) {
//	//	negativeAssoc += pmi[item.first].begin()->second;
//	//}
//}

__global__ void addPositive(string* positiveVocab) {
	int i = threadIdx.x;
	// count positive
	// count negative

}


//cudaError_t sentimentAnalysis(vector<string> positiveVocab, vector<string> negativeVocab, vector<string> allTerms, unsigned int posSize, unsigned int negSize, unsigned int termSize) {
//	cudaError_t cudaStatus;
//
//
//	string* d_positiveVocab = 0;
//	string* d_negativeVocab = 0;
//	string* d_allTerms = 0;
//
//
//	// Select GPU in PCIE slot 1 to run on.
//	cudaStatus = cudaSetDevice(0);
//	if (cudaStatus != cudaSuccess) {
//		fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
//		goto Error;
//	}
//
//	// Allocate GPU buffers for three vectors (two input, one output)    .
//	cudaStatus = cudaMalloc((void**)&d_positiveVocab, posSize * sizeof(string));
//	if (cudaStatus != cudaSuccess) {
//		fprintf(stderr, "cudaMalloc failed!");
//		goto Error;
//	}
//
//	cudaStatus = cudaMalloc((void**)&d_negativeVocab, negSize * sizeof(string));
//	if (cudaStatus != cudaSuccess) {
//		fprintf(stderr, "cudaMalloc failed!");
//		goto Error;
//	}
//
//	cudaStatus = cudaMalloc((void**)&d_allTerms, termSize * sizeof(string));
//	if (cudaStatus != cudaSuccess) {
//		fprintf(stderr, "cudaMalloc failed!");
//		goto Error;
//	}
//
//	// Copy input vectors from host memory to GPU buffers.
//	cudaStatus = cudaMemcpy(d_positiveVocab, &positiveVocab, posSize * sizeof(string), cudaMemcpyHostToDevice);
//	if (cudaStatus != cudaSuccess) {
//		fprintf(stderr, "cudaMemcpy failed!");
//		goto Error;
//	}
//
//	cudaStatus = cudaMemcpy(d_negativeVocab, &negativeVocab, negSize * sizeof(string), cudaMemcpyHostToDevice);
//	if (cudaStatus != cudaSuccess) {
//		fprintf(stderr, "cudaMemcpy failed!");
//		goto Error;
//	}
//
//	// Launch a kernel on the GPU with one thread for each element.
//	addPositive << <1, posSize >> > (d_positiveVocab);
//
//	// Check for any errors launching the kernel
//	cudaStatus = cudaGetLastError();
//	if (cudaStatus != cudaSuccess) {
//		fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
//		goto Error;
//	}
//
//	// cudaDeviceSynchronize waits for the kernel to finish, and returns
//	// any errors encountered during the launch.
//	cudaStatus = cudaDeviceSynchronize();
//	if (cudaStatus != cudaSuccess) {
//		fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
//		goto Error;
//	}
//
//	// Copy output vector from GPU buffer to host memory.
//	cudaStatus = cudaMemcpy(d_allTerms, &allTerms, termSize * sizeof(int), cudaMemcpyDeviceToHost);
//	if (cudaStatus != cudaSuccess) {
//		fprintf(stderr, "cudaMemcpy failed!");
//		goto Error;
//	}
//
//Error:
//	cudaFree(d_positiveVocab);
//	cudaFree(d_negativeVocab);
//	cudaFree(d_allTerms);
//
//
//	return cudaStatus;
//}



__global__ void denomKernel(float* d_p_t_Vector, float* d_denom_Vector, int n) {
	int i = threadIdx.x;

	if (i < n) {
		d_denom_Vector[i] = d_p_t_Vector[i];
	}



}

// Helper function for using CUDA to add vectors in parallel.
cudaError_t denomCuda(float* p_t_Vector, float* denom_Vector, unsigned int p_t_size, unsigned int denom_size)
{
	float* d_p_t_Vector = 0;
	float* d_denom_Vector = 0;
	cudaError_t cudaStatus;
	vector<float> tempting;
	for (int i = 0; i < p_t_size; i++) {
		tempting.push_back(p_t_Vector[i]);

	}

	for (auto item : tempting) {
		cout << item << endl;
	}

	cout << tempting.data() << endl;
	cout << denom_Vector << endl;

	//cout << denom_Vector[155] << endl;
	//cout << &p_t_Vector[2] << endl;
	//cout << &denom_Vector[155] << endl;

	cout << p_t_Vector[0] << endl;



	// Choose which GPU to run on
	cudaStatus = cudaSetDevice(0);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
		goto Error;
	}

	cudaStatus = cudaMallocManaged(&d_p_t_Vector, p_t_size * sizeof(float));
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMalloc failed!");
		goto Error;
	}

	// Copy input vectors from host memory to GPU buffers.
	cudaStatus = cudaMemcpy(d_p_t_Vector, &p_t_Vector, p_t_size * sizeof(float), cudaMemcpyHostToDevice);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy failed!");
		goto Error;
	}


	cudaStatus = cudaMallocManaged((float**)&d_denom_Vector, denom_size * sizeof(float));
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMalloc failed!");
		goto Error;
	}



	// Launch a kernel on the GPU with one thread for each element.
	denomKernel <<<1, p_t_size >>> (p_t_Vector, d_denom_Vector, p_t_size);

	// Check for any errors launching the kernel
	cudaStatus = cudaGetLastError();
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
		goto Error;
	}

	// cudaDeviceSynchronize waits for the kernel to finish, and returns
	// any errors encountered during the launch.
	cudaStatus = cudaDeviceSynchronize();
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching denomKernel!\n", cudaStatus);
		goto Error;
	}

	// Copy output vector from GPU buffer to host memory.
	cudaStatus = cudaMemcpy(denom_Vector, d_denom_Vector, denom_size * sizeof(float), cudaMemcpyDeviceToHost);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy failed!");
		goto Error;
	}

Error:
	cudaFree(d_p_t_Vector);
	cudaFree(d_denom_Vector);

	return cudaStatus;
}





// Comparator function to sort pairs
// according to second value
bool cmp(pair<string, float>& a,
	pair<string, float>& b)
{
	return a.second < b.second;
}

// Function to sort the map according
// to value in a (key-value) pairs
void sort(map<string, float>& M)
{

	// Declare vector of pairs
	vector<pair<string, float> > A;

	// Copy key-value pair from Map
	// to vector of pairs
	for (auto& it : M) {
		A.push_back(it);
	}

	sort(A.begin(), A.end(), cmp);

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



		// then make a com vector
		for (auto term1 : countAll) {
			p_t[term1.first] = term1.second / n_docs;
			for (auto term2 : com[term1.first]) {
				p_t_com[term1.first][term2.first] = com[term1.first][term2.first] / n_docs;
			}
		}

		// first make a demon vector

		int arraySize = countAll.size() * (countAll.size() - 1);

		vector<float> temp;

		float* denomVec = new float[arraySize];

		float justP_t[100] = { 0 };
		memset(justP_t, 0, 4 * countAll.size());

		
		// Make this paralell
		count = 0;
		for (auto term : p_t) {
			justP_t[count] = term.second;
			count++;
		}
	

	/*	float* justP_t = &temp[0];*/

		memset(denomVec, 0.1, 4 * arraySize);



		// Add vectors in parallel.
		cudaError_t cudaStatus = denomCuda(justP_t, denomVec, p_t.size(), arraySize);
		if (cudaStatus != cudaSuccess) {
			fprintf(stderr, "kernal failed!");
			return 1;
		}


	//cout << denomVec[0] << endl;
	//cout << denomVec[1] << endl;
	//cout << denomVec[2] << endl;
	//cout << denomVec[3] << endl;
	//cout << denomVec[4] << endl;
	//cout << justP_t[5] << endl;
	//cout << justP_t[6] << endl;
	//cout << justP_t[7] << endl;
	//cout << justP_t[8] << endl;
	//cout << justP_t[9] << endl;
	//cout << justP_t[10] << endl;
	//cout << justP_t[11] << endl;
	//cout << justP_t[12] << endl;
		delete[] justP_t;
		delete[] denomVec;

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




// Old version might use parts of it later.
//// Add vectors in parallel.
	//cudaError_t cudaStatus = sentimentAnalysis(positiveVocab, negativeVocab, allTerms, positiveVocab.size(), negativeVocab.size(), allTerms.size());
	//if (cudaStatus != cudaSuccess) {
	//	fprintf(stderr, "sentimentAnalysis failed!");
	//	return 1;
	//}


		//// cudaDeviceReset must be called before exiting in order for profiling and
		//// tracing tools such as Nsight and Visual Profiler to show complete traces.
		//cudaStatus = cudaDeviceReset();
		//if (cudaStatus != cudaSuccess) {
		//	fprintf(stderr, "cudaDeviceReset failed!");
		//	return 1;
		//}




//
//
//
//	string h_positiveVocab[] = { "good", "nice", "great", "awesome", "outstanding","fantastic", "terrific", ":)", ":-)", "like", "love", "triumph", "triumphal", "triumphant", "victory" };
//	string h_negativeVocab[] = { "bad", "terrible", "crap", "useless", "hate", ":(", ":-(", "died", "dead", "defeat", "sick", "despair", "death", "deaths" };
//
//	int posCount = sizeof(h_positiveVocab), negCount = sizeof(h_negativeVocab);
//	string* d_positiveVocab, * d_negativeVocab, * d_dataKeyArray, * d_item;
//	float* d_dataValueArray;
//	const int posSize = posCount * sizeof(string);
//	const int negSize = negCount * sizeof(string);
//	cudaMalloc(&d_positiveVocab, posSize);
//	cudaMalloc(&d_negativeVocab, negSize);
//	cudaMemcpy(d_positiveVocab, h_positiveVocab, posSize, cudaMemcpyKind::cudaMemcpyHostToDevice);
//	cudaMemcpy(d_negativeVocab, h_negativeVocab, negSize, cudaMemcpyKind::cudaMemcpyHostToDevice);
//	map <string, float> out;
//	map <string, float> semanticOrientation;
//	// semantic orientation
//	for (auto item : out) {
//		float positiveAssoc = 0;
//		float negativeAssoc = 0;
//		// Split map to copy to device
//		const int dataCount = sizeof(pmi[item.first]);
//		string h_dataKeyArray[dataCount], h_item;
//		float h_dataValueArray[dataCount];
//		int tempCount = 0;
//		for (auto data : pmi[item.first]) {
//			h_dataKeyArray[tempCount] = item.first;
//			h_dataValueArray[tempCount] = item.second;
//			h_item = item.first;
//			tempCount++;
//			//Make Copy to Device
//			const int dataKeyArraySize = dataCount * sizeof(string), dataValueArraySize = dataCount * sizeof(float), itemSize = sizeof(string);
//			cudaMalloc(&d_item, itemSize);
//			cudaMalloc(&d_dataKeyArray, dataKeyArraySize);
//			cudaMalloc(&d_dataValueArray, dataValueArraySize);
//			cudaMemcpy(d_dataKeyArray, h_dataKeyArray, dataKeyArraySize, cudaMemcpyKind::cudaMemcpyHostToDevice);
//			cudaMemcpy(d_dataValueArray, h_dataValueArray, dataValueArraySize, cudaMemcpyKind::cudaMemcpyHostToDevice);
//			sentimentAnalysis <<<1, 10 >>> (d_positiveVocab, d_negativeVocab, d_dataKeyArray, d_dataValueArray, d_item);
//		}
//
//
//		semanticOrientation[item.first] = positiveAssoc - negativeAssoc;
//
//	}
//
//
//
//	// sort map
//	//sort(semanticOrientation.begin(), semanticOrientation.end(), [](const auto& x, const auto& y) {return x.second < y.second;});
//	sort(semanticOrientation);
//
//
//	cout << "Top Positive";
//	for (auto i = semanticOrientation.begin();i != semanticOrientation.end(); i++) {
//		cout << i->first
//			<< " = "
//			<< i->second
//			<< endl;
//	}
//
//	cout << endl;
//
//	//print in reverse order from worst to best.
//	cout << "Top Negative";
//	for (auto i = semanticOrientation.rbegin(); i != semanticOrientation.rend(); i++) {
//		cout << i->first
//			<< " = "
//			<< i->second
//			<< endl;
//	}
//
//	cout.flush();
//	std::system("pause");
//	return;
//}

// Sort terms
//sort(terms.begin(), terms.end());