%include talk.fmt
\section{Introduction}
\subsection{What is \texorpdfstring{\clash{}}{CLasH}}
\frame
{
  \frametitle{What is \clash{}?}
  \begin{itemize}
    \item \clash{}: CAES Language for Hardware Descriptions
    \item Rapid prototyping language
    \item Subset of Haskell can be translated to Hardware (VHDL)
    \item Structural Description of a Mealy Machine
  \end{itemize}
}
\note[itemize]
{
\item We are a Computer Architectures group, this has been a 6 month project, no prior experience with Haskell.
\item \clash{} is written in Haskell, of course
\item \clash{} is currently meant for rapid prototyping, not verification of hardware desigs
\item Functional languages are close to Hardware
\item We can only translate a subset of Haskell
\item All functions are descriptions of Mealy Machines
}

\subsection{Mealy Machine}
\frame
{
\frametitle{What again is a Mealy Machine?}
  \begin{figure}
  \centerline{\includegraphics[width=10cm]{mealymachine}}
  \label{img:mealymachine}
  \end{figure}
}
\note[itemize]{
\item Mealy machine bases its output on current input and previous state
}

\frame
{
\frametitle{Haskell Description}
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
mealyMachine :: 
  InputSignals ->
  {-"{\color<2>[rgb]{1,0,0}"-}State{-"}"-} ->
  (State, OutputSignals)
mealyMachine inputs {-"{\color<2>[rgb]{1,0,0}"-}state{-"}"-} = ({-"{\color<3>[rgb]{1,0,0}"-}new_state{-"}"-}, output)
  where
    {-"{\color<3>[rgb]{1,0,0}"-}new_state{-"}"-}    =   logic     {-"{\color<2>[rgb]{1,0,0}"-}state{-"}"-}   input
    outputs                                         =   logic     {-"{\color<2>[rgb]{1,0,0}"-}state{-"}"-}   input
\end{code}
\end{beamercolorbox}
\begin{itemize}
\uncover<2->{\item Current state is part of the input}
\uncover<3->{\item New state is part of the output}
\end{itemize}
}
\note[itemize]{
\item State is part of the function signature
\item Both the current state, as the updated State
}

\subsection{Simulation}
\frame
{
\frametitle{Simulating a Mealy Machine}
\begin{beamercolorbox}[sep=-2.5ex,rounded=true,shadow=true,vmode]{codebox}
\begin{code}
run func {-"{\color<2>[rgb]{1,0,0}"-}state{-"}"-} [] = []
run func {-"{\color<2>[rgb]{1,0,0}"-}state{-"}"-} (i:input) = o:out
  where
    ({-"{\color<3>[rgb]{1,0,0}"-}state'{-"}"-}, o)  =   func i {-"{\color<2>[rgb]{1,0,0}"-}state{-"}"-}
    out                                             =   run func {-"{\color<3>[rgb]{1,0,0}"-}state'{-"}"-} input
\end{code}
\end{beamercolorbox}
\begin{itemize}
\item State behaves like an accumulator
\end{itemize}
}
\note[itemize]{
\item This is just a quick example of how we can simulate the mealy machine
\item It sort of behaves like MapAccumN
}

